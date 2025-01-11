class CreatePixJob < ApplicationJob
  queue_as :default

  attr_reader :qr_code

  def perform(charge_id)
    @charge_id = charge_id
    pix_qr_code
  end

  def pix_qr_code
    request = Asaas::Base.new("/api/v3/payments/#{@payment_id}/pixQrCode").index
    response = JSON.parse(request.read_body)
    @qr_code = response["qrCode"]
    @client.payments.last.update_attribute(:qr_code, qr_code)
    Rails.logger.info("[Create Client Job] - created QR Code: #{qr_code}")
  rescue StandardError => e
    Rails.logger.error("[Create Client Job] - Error to create QR Code: #{e.message}")
  end

  def set_client
    @client = Marriage.find_by_uuid(@client_uuid)
  rescue ActiveRecord::RecordNotFound
    Rails.logger.error("[Create Client Job] - Client not found")
  end

  def charge_value
    ENV["CHARGE_VALUE"].to_f
  end

  def day_to_expire
    ENV["DAYS_TO_EXPIRE"].to_i
  end
end
