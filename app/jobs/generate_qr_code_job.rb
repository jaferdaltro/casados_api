class GenerateQrCodeJob < ApplicationJob
  queue_as :default

  def perform(*args)
    asaas = Asaas::PixCreate.new
    response = asaas.create
    result = response.read_body
    JSON.parse(result)
  end
end
