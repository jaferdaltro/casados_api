class CreatePixJob < ApplicationJob
  # include Sidekiq::Worker
  # include Sidekiq::Status::Worker
  queue_as :default

  attr_reader :qr_code

  def perform(uuid, payment_id, status, type, value, due_date)
    @client_uuid = uuid
    @payment_id = payment_id
    @status = status
    @type = type
    @value = value
    @due_date = due_date
    pix_qr_code
    # at(100, "Final job completed")
  end

  def pix_qr_code
    request = Asaas::Base.new("/api/v3/payments/#{@payment_id}/pixQrCode").index
    response = JSON.parse(request.read_body)
    if request.code == "200"
      set_client
      @qr_code = response
      Payment.create!(
        marriage_id: @client.id,
        asaas_payment_id: @payment_id,
        qr_code: @qr_code,
        status: @status,
        payment_method: @type,
        amount: @value,
        due_date: @due_date
      )
      Rails.logger.info("[Create PIX Job] - created QR Code: #{qr_code}")
    end
  rescue StandardError => e
    Rails.logger.error("[Create PIX Job] - Error to create QR Code: #{e.message}")
  end

  def set_client
    @client = Marriage.find_by_uuid(@client_uuid)
  rescue ActiveRecord::RecordNotFound
    Rails.logger.error("[Create PIX Job] - Client not found")
  end
end
