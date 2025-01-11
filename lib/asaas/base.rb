require "uri"
require "net/http"

module Asaas
  class Base
    def initialize(url)
      # base_url = Rails.env == "production" ?
      #   URI(ENV["ASAAS_PRODUCTION_URL"]) :
      #   URI(ENV["ASAAS_SANDBOX_URL"])
      base_url = URI(ENV["ASAAS_SANDBOX_URL"])
      @url = base_url.merge(url)
      @http = Net::HTTP.new(@url.host, @url.port)
      @http.use_ssl = true
    end

    def index
      request = Net::HTTP::Get.new(@url)
      request["accept"] = "application/json"
      request["access_token"] = ENV["ASAAS_TOKEN"]
      @http.request(request)
    end

    def create(body)
      request = Net::HTTP::Post.new(@url)
      request["accept"] = "application/json"
      request["content-type"] = "application/json"
      request["access_token"] = ENV["ASAAS_TOKEN"]
      request.body = body
      @http.request(request)
    end
  end
end
