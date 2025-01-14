class CreatePixJob < ApplicationJob
  queue_as :default

  attr_reader :qr_code

  def perform(uuid, customer, payment_id, status, value)
    @client_uuid = uuid
    @payment_id = payment_id
    @status = status
    @value = value
    @asaas_client_id = customer
    pix_qr_code
  end

  def pix_qr_code
    request = Asaas::Base.new("/api/v3/payments/#{@payment_id}/pixQrCode").index
    response = JSON.parse(request.read_body)
    if request.code == "200"
      set_client
      @qr_code = response['payload']
      create_payment
      Rails.logger.info("[CREATE PIX] - created QR Code: #{qr_code}")
    end
  rescue StandardError => e
    Rails.logger.error("[CREATE PIX] - Error to create QR Code: #{e.message}")
  end

  def create_payment
    Payment.create!(
      marriage_id: @client.id,
      asaas_payment_id: @payment_id,
      qr_code: @qr_code,
      status: set_status(@status),
      payment_method: :PIX,
      amount: @value,
      asaas_client_id: @asaas_client_id,
      uuid: @client_uuid
    )
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error("[CREATE PIX] - Error to create Payment into DB: #{e.record.errors}")
  end

  def set_status status
    case status
    when "PENDING" then :PENDING
    when "CONFIRMED" then :CONFIRMED
    end
  end

  def set_client
    @client = Marriage.find_by_uuid(@client_uuid)
  rescue ActiveRecord::RecordNotFound
    Rails.logger.error("[Create PIX Job] - Client not found")
  end
end
