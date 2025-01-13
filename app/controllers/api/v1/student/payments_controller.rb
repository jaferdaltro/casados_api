module API::V1
  class Student::PaymentsController < ApplicationController
    before_action :set_client

    def create_pix
     CreateClientJob.perform_now(params[:marriage_uuid], args = nil)
     payload = nil
     count = 0
     while payload.nil? || count == 10 do
      payload = @client.payments&.last.qr_code
      count += 1
      sleep 1
     end
     unless payload.nil?
      render json: { pix: payload }, status: :created
     else
      render json: { error: "Não foi possível criar a chave PIX" }, status: :unprocessable_entity
     end
    end

    def create_credit_card
      CreateClientJob.perform_now(params[:marriage_uuid], args = credit_card_params)
      render json: { credit_card: "processando pagamento" }, status: :created
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
      payment.update_attribute(:status, status)
      marriage.update_attribute(:active, true)
      set_size(marriage)
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
        marriage.husband.update_attribute(:t_shirt_size, husband_size_params)
        marriage.wife.update_attribute(:t_shirt_size, wife_size_params)
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

    def husband_size_params
      return {} unless params[:husband_size]

      params.require(:husband_size).permit(:P, :M, :G, :GG, :XG)
    end

    def wife_size_params
      return {} unless params[:wife_size]

      params.require(:wife_size).permit(:P, :M, :G, :GG, :XG)
    end

    def credit_card_params
      return {} unless params[:creditCard]

      params.require(:creditCard).permit(:holderName, :number, :expiryMonth, :expiryYear, :ccv)
    end
  end
end
