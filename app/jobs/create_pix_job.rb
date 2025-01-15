class CreatePixJob < ApplicationJob
  queue_as :default

  attr_reader :qr_code

  def perform(payment_id)
    request = Asaas::Base.new("/api/v3/payments/#{payment_id}/pixQrCode").index
    response = JSON.parse(request.read_body)
    response
  end
end
