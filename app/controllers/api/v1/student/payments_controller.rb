module API::V1
  class Student::PaymentsController < ApplicationController
    before_action :set_client, only: [ :create_pix, :create_credit_card ]

    def create_pix
      return render json: { error: "Pagamento já foi efetuado" }, status: :unprocessable_entity if @client.active

      result = CreateClientJob.perform_now(params[:marriage_uuid], "PIX", args = nil)
      if result["status"] == "PENDING"
        charge = persist_charge(result, @client)
        result = CreatePixJob.perform_now(result["id"])
        if result["success"]
          payload = result["payload"]
          set_size(@client)
          charge.update_attribute(:qr_code, payload)
          render json: { code: payload }, status: :created
        end
      elsif result.nil?
        render json: { error: "houve um erro ao processar o pagamento" }, status: :unprocessable_entity
      else
        render json: { message: result["errors"].first["description"] }, status: :unprocessable_entity
      end
    end

    def create_credit_card
      return render json: { error: "Pagamento já foi efetuado" }, status: :unprocessable_entity if @client.active

      result = CreateClientJob.perform_now(params[:marriage_uuid], "CREDIT_CARD", args = credit_card_params)
      if result["status"] == "CONFIRMED"
        persist_charge(result, @client)
        set_size(@client)
        render json: { credit_card_status: result["status"] }, status: :created
      elsif result.nil?
        render json: { error: "houve um erro ao processar o pagamento" }, status: :unprocessable_entity
      else
        render json: { message: result["errors"].first["description"] }, status: :unprocessable_entity
      end
    end

    def payment_status
      payment = Payment.where(uuid: params[:uuid]).last
      return render json: { error: "Payment not found" }, status: :not_found if payment.nil?

      render json: {
        uuid: payment.uuid,
        value: payment.amount,
        type: payment.payment_method,
        status: payment.status
      }, status: :ok
    end

    def webhook
      status = set_status(params[:payment][:status])
      payment_id = params[:payment][:id]
      payment = Payment.find_by_asaas_payment_id(payment_id)
      marriage = payment.marriage

      payment.update_attribute(:status, status) unless payment.nil?
      marriage.update_attribute(:active, true) unless marriage.nil?
    rescue ActiveRecord::RecordNotFound => e
      Rails.logger.error("[WEBHOOK] - Record not found - Error: #{e}")
    rescue StandardError => e
      Rails.logger.error("[WEBHOOK] - Error: #{e}")
    end

    private

    def set_status(status)
      case status
      when "CREATED" then :CREATED
      when "PENDING" then :PENDING
      when "RECEIVED" then :RECEIVED
      when "CONFIRMED" then :CONFIRMED
      when "CANCELED" then :CANCELED
      end
    end

    def set_size(marriage)
      ActiveRecord::Base.transaction do
        marriage.husband.update_attribute(:t_shirt_size, sizes_params[:husband])
        marriage.wife.update_attribute(:t_shirt_size, sizes_params[:wife])
      end
    rescue ActiveRecord::RecordNotFound => e
      Rails.logger.error("[Create Client] - Client not found")
    rescue StandardError => e
      Rails.logger.error("[Create Client] - Error: #{e}")
    end

    def set_client
      @client = Marriage.find_by_uuid(params[:marriage_uuid])
    rescue ActiveRecord::RecordNotFound
      Rails.logger.error("[Create PIX Job] - Client not found")
    end

    def persist_charge(response, client)
      Payment.create!(
        marriage_id: client.id,
        asaas_payment_id: response["id"],
        status: set_status(response["status"]),
        payment_method: response["billingType"].to_sym,
        amount: response["value"],
        uuid: client.uuid,
        asaas_client_id: response["customer"],
        due_date: response["dueDate"].to_date
      )
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error("[CREATE CHARGE] - Error to create Payment into DB: #{e.record.errors}")
    end

    def sizes_params
      return {} unless params[:sizes]

      params.require(:sizes).permit(:husband, :wife)
    end

    def credit_card_params
      return {} unless params[:payment]

      params.require(:payment)
        .permit(:installmentCount, creditCard: [ :holderName, :number, :expiryMonth, :expiryYear, :ccv ])
    end
  end
end
