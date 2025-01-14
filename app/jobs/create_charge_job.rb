class CreateChargeJob < ApplicationJob
  # include Sidekiq::Worker
  # include Sidekiq::Status::Worker
  queue_as :default


  def perform(asaas_id, uuid, billing_type, payment_args = nil)
    @payment_args = payment_args if payment_args.present?
    @uuid = uuid
    @asaas_id = asaas_id
    @billing_type = billing_type
    create_charge
  end

  def create_charge
    @billing_type == 'CREDIT_CARD' ?
      charge_payload = build_charge.merge(@payment_args).symbolize_keys :
      charge_payload = build_charge
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


  # def persist_charge(response)
  #   set_client

  #   Payment.create!(
  #     marriage_id: @client.id,
  #     asaas_payment_id: response['id'],
  #     status: set_status(response['status']),
  #     payment_method: response['billingType'].to_sym,
  #     amount: response['value'],
  #     uuid: @uuid,
  #     asaas_client_id: response['customer'],
  #     due_date: response['dueDate'].to_date
  #   )
  # rescue ActiveRecord::RecordInvalid => e
  #   Rails.logger.error("[CREATE CHARGE] - Error to create Payment into DB: #{e.record.errors}")
  # end

  # def set_client
  #   @client = Marriage.find_by_uuid(@uuid)
  # rescue ActiveRecord::RecordNotFound
  #   Rails.logger.error("[Create Client] - Client not found")
  # end

  # def set_status status
  #   case status
  #   when "PENDING" then :PENDING
  #   when "CONFIRMED" then :CONFIRMED
  #   end
  # end

  def build_charge
    installment_count =  @payment_args['installmentCount'].present? ? @payment_args['installmentCount'] : nil
    total_value = installment_count.present? ? charge_value : nil

    {
      customer: @asaas_id,
      billingType: @billing_type,
      value: charge_value,
      totalValue:total_value,
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
