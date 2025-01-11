class CreateChargeJob < ApplicationJob
  queue_as :default

  attr_reader :payment_id, :status, :type, :value, :due_date

  def perform(asaas_id)
    @asaas_id = asaas_id
    create_charge
  end

  def create_charge
    request = Asaas::Base.new("/api/v3/payments").create(build_charge)
    response = JSON.parse(request.read_body)
    @payment_id = response["id"]
    @status = response["status"]
    @type = response["billingType"]
    @value = response["value"]
    @due_date = response["dueDate"]

    Rails.logger.info("[Create Client Job] - created charge: #{@client_name}")
  rescue StandardError => e
    Rails.logger.error("[Create Client Job] - Error: #{e.message}")
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
    ENV["CHARGE_VALUE"].to_f
  end

  def day_to_expire
    ENV["DAYS_TO_EXPIRE"].to_i
  end
end
