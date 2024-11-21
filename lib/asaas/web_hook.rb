require "uri"
require "net/http"

module Asaas
  class WebHook
    def initialize
      @http = Net::HTTP.new(url.host, url.port)
      @http.use_ssl = true
    end

    def handle_weebhook
      request = Net::HTTP::Post.new(url)
      request["type"] = "application/json"
      body = JSON.parse(request.body)

      event = body[:event]
      # payment = body[:payment]

      case event
      when "PAYMENT_CREATED"
        puts "pagamento criado"
      when "PAYMENT_AUTHORIZED"
        puts "pagamento autorizado"
      when "PAYMENT_CONFIRMED"
        puts "pagamento confirmado"
      when "PAYMENT_RECEIVED"
        puts "pagamento recebido"
      else
        puts "esse evento n é aceito"
      end
    end

    private

    def url
      @url = URI("https://casados-api.fly.dev/webhook/asaas")
    end
  end
end
