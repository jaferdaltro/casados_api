class CreateChargeJob < ApplicationJob
  queue_as :default

  def perform(asaas_id, uuid, billing_type, payment_args = nil)
    @payment_args = payment_args if payment_args.present?
    @uuid = uuid
    @asaas_id = asaas_id
    @billing_type = billing_type
    create_charge
  end

  def create_charge
    charge_payload =  @billing_type == "CREDIT_CARD" ? build_charge.merge(@payment_args).symbolize_keys : build_charge
    charge_payload_json  = charge_payload.to_json
    request = Asaas::Base.new("/api/v3/payments").create(charge_payload_json)
    response = JSON.parse(request.read_body)
    Rails.logger.info("[CREATE CHARGE] - created charge: #{response['billingType']}, status: #{response['status']}, "\
    "#{response['id']}")
    response
  rescue StandardError => e
    Rails.logger.error("[CREATE CHARGE] - response code error: #{request.code} - Error: #{e.message}")
  end

  private

  def build_charge
    total_value = charge_value if @billing_type == "CREDIT_CARD"

    {
      customer: @asaas_id,
      billingType: @billing_type,
      value: charge_value,
      totalValue: total_value,
      dueDate: Date.today + day_to_expire,
      description: "Inscrição de MMI"
    }
  end

  def charge_value
    ENV["PIX_VALUE"].to_f
  end

  def day_to_expire
    ENV["DAYS_TO_EXPIRE"].to_i
  end
end
