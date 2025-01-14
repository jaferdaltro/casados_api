class CreateClientJob < ApplicationJob
  queue_as :default

  def perform(uuid, billing_type, payment_args)
    @uuid = uuid
    @payment_args = payment_args if payment_args.present?
    @billing_type = billing_type
    set_client
    create_client
  end

  def create_client
    name = @client.husband.name
    request = Asaas::Base.new("/api/v3/customers").create(build_client)
    response = JSON.parse(request.read_body)
    if request.code == "200"
      asaas_id = response["id"]
      Rails.logger.info("[Create Client Job] - created Client: #{name}")
      CreateChargeJob.perform_now(asaas_id, @uuid, @billing_type, @payment_args)
    else
      Rails.logger.error("[Create Client Job] - Error: request code #{request.code}")
    end
  rescue StandardError => e
    Rails.logger.error("[Create Client Job] - Error: #{e.message} - request code: #{request.code}")
  end

  def build_client
    {
      name: @client.husband.name,
      cpfCnpj: @client.husband.cpf
    }.to_json
  end

  private

  def set_client
    @client = Marriage.find_by_uuid(@uuid)
  rescue ActiveRecord::RecordNotFound
    Rails.logger.error("[Create Client] - Client not found")
  end
end
