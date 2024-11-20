module Asaas
  class PixCreate < Base
    def body
      {
        addressKey: ENV["PIX_KEY"],
        description: "Inscrição MMI",
        value: 50,
        format: "ALL",
        expirationDate: future_date,
        expirationSeconds: nil,
        allowsMultiplePayments: true,
        externalReference: nil
      }.to_json
    end

    def future_date
      current_date = Date.today
      date_3_days_ahead = current_date + 3.days
      current_time = Time.now
      time_3_days_ahead = current_time + 3.days

      date_3_days_ahead.change(hour: current_time.hour, min: current_time.min, sec: current_time.sec)
    end
  end
end
