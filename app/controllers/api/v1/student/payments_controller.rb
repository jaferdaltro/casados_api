module API::V1
  class Student::PaymentsController < ApplicationController
    before_action :set_client, only: %i[create]

    def create
      asaas_id =  set_asaas_id(@client)
      charge = CreateChargeJob.perform_now(asaas_id)
      @client.payments.create(
        asaas_client_id: asaas_id,
        amount: charge.value,
        payment_method: :PIX,
        value: charge.value,
        due_date: charge.due_date,
        asaas_payment_id: charge.payment_id,
        description: "Inscrição de MMI"
      )
      charge_id = charge.payment_id
      CreatePixJob.perform_now(charge_id)
    end

    private

    def set_asaas_id(client)
      client = Marriage.find_by_uuid(params[:marriage_uuid])
      if client.id_asaas.blank?
        name = @client.husband.name
        cpf = @client.husband.cpf
        client = CreateClientJob.perform_now(name, cpf)
        client.asaas_id
      else
        client.id_asaas
      end
    rescue ActiveRecord::RecordNotFound
      Rails.logger.error("[Create Client] - Client not found")
    end

    def set_client
      @client = Marriage.find_by_uuid(params[:marriage_uuid])
    rescue ActiveRecord::RecordNotFound
      Rails.logger.error("[Create Client] - Client not found")
    end
  end
end
