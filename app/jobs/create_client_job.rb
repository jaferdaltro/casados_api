class CreateClientJob < ApplicationJob
  queue_as :default

  def perform(uuid)
    set_client(uuid)
    create_client
  end

  def create_client
    name = @client.husband.name
    uuid = @client.uuid
    request = Asaas::Base.new("/api/v3/customers").create(build_client)
    response = JSON.parse(request.read_body)
    if request.code == "200"
      asaas_id = response["id"]
      Rails.logger.info("[Create Client Job] - created Client: #{name}")
      CreateChargeJob.perform_now(asaas_id, uuid)
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

  def set_client(uuid)
    @client = Marriage.find_by_uuid(uuid)
  rescue ActiveRecord::RecordNotFound
    Rails.logger.error("[Create Client] - Client not found")
  end
end
