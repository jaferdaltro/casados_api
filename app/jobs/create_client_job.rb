class CreateClientJob < ApplicationJob
  queue_as :default

  attr_reader :asaas_id

  def perform(name, cpf)
    @name = name
    @cpf = cpf
    create_client
  end

  def create_client
    request = Asaas::Base.new("/api/v3/customers").create(build_client)
    response = JSON.parse(request.read_body)
    @asaas_id = response["id"]
    client.update_attribute(:id_asaas, @asaas_id)
    Rails.logger.info("[Create Client Job] - created Client: #{@client_name}")
  rescue StandardError => e
    Rails.logger.error("[Create Client Job] - Error: #{e.message}")
  end

  def build_client
    {
      name: @name,
      cpfCnpj: @cpf
    }.to_json
  end
end
