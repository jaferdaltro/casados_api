require "uri"
require "net/http"

module Asaas
  class PixCharge
    def initialize
      @url = URI("#{ENV["ASAAS_SANDBOX_URL"]}/pix/qrCodes/static")
      @http = Net::HTTP.new(@url.host, @url.port)
      @http.use_ssl = true
    end

    def create
      request = Net::HTTP::Post.new(@url)
      request["accept"] = "application/json"
      request["content-type"] = "application/json"
      request["access_token"] = ENV["ASAAS_TOKEN"]
      request.body = body
      @http.request(request)
    end

    private
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
