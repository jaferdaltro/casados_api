class CreateChargeJob < ApplicationJob
  # include Sidekiq::Worker
  # include Sidekiq::Status::Worker
  queue_as :default


  def perform(asaas_id, uuid, payment_args = nil)
    @payment_args = payment_args if payment_args.present?
    @uuid = uuid
    @asaas_id = asaas_id
    create_charge
  end

  def create_charge
    request = Asaas::Base.new("/api/v3/payments").create(build_charge)
    response = JSON.parse(request.read_body)
    if request.code == "200"
      payment_id = response["id"]
      status = response["status"]
      customer = response["customer"]
      value = response["value"].to_f
      @payment_args.present? ?
        CreateCreditJob.perform_now(@uuid, payment_id, @payment_args) :
        CreatePixJob.perform_now(@uuid,customer, payment_id, status, value)
    else
      Rails.logger.error("[CREATE CHARGE] - Error to create charge: #{response['errors'].last["description"]}")
    end

    Rails.logger.info("[CREATE CHARGE] - created charge: #{@asaas_id}")
  rescue StandardError => e
    Rails.logger.error("[CREATE CHARGE] - Error: #{e.message}")
  end

  def build_charge
    {
      customer: @asaas_id,
      billingType: "PIX",
      value: charge_value,
      dueDate: Date.today + day_to_expire,
      description: "Inscrição de MMI"
    }.to_json
  end

  def charge_value
    ENV["PIX_VALUE"].to_f
  end

  def day_to_expire
    ENV["DAYS_TO_EXPIRE"].to_i
  end
end
