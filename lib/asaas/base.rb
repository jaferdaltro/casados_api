require "uri"
require "net/http"

module Asaas
  class Base
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
  end
end
