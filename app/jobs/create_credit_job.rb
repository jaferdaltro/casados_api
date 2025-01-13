class CreateCreditJob < ApplicationJob
  queue_as :default

  # @uuid, payment_id, @payment_args
  def perform(uuid, payment_id, params)
    @params = { creditCard: params }.to_json
    @uuid = uuid
    @payment_id = payment_id
    create_charge
  end

  def create_charge
    request = Asaas::Base.new("/api/v3/payments/#{@payment_id}/payWithCreditCard").create(@params)
    response = JSON.parse(request.read_body)
    if request.code == "200"
      @status = response["status"]
      @value = response["value"].to_f
      @due_date = response["dueDate"]
      @asaas_client_id = response["customer"]
      persist_payment
      Rails.logger.info("[CREATE CREDIT] - created credit: #{@status}")
    else
      Rails.logger.error("[CREATE CREDIT] - Error: request code #{request.code}")
    end
  rescue StandardError => e
    Rails.logger.error("[CREATE CREDIT] - Error: #{e.message} - request code: #{request.code}")
  end


  private

  def set_client
    @client = Marriage.find_by_uuid(@uuid)
  rescue ActiveRecord::RecordNotFound
    Rails.logger.error("[Create Client] - Client not found")
  end

  def set_status status
    case status
    when "PENDING" then :PENDING
    when "CONFIRMED" then :CONFIRMED
    end
  end

  def persist_payment
    set_client
    Payment.create!(
      marriage_id: @client.id,
      asaas_payment_id: @payment_id,
      status: set_status(@status),
      payment_method: :CREDIT_CARD,
      amount: @value,
      uuid: @uuid,
      asaas_client_id: @asaas_client_id,
      due_date: @due_date
    )
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error("[CREATE CREDIT] - Error to create Payment into DB: #{e.record.errors}")
  end
end
