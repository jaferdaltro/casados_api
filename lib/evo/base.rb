require "uri"
require "net/http"

module Evo
  class Base
    def initialize
      url =  "#{evo_url}#{evo_instance}"
      base_url = URI(url)
      @url = base_url.merge(base_url)
      @http = Net::HTTP.new(@url.host, @url.port)
      @http.use_ssl = false
    end

    def create(body)
      request = Net::HTTP::Post.new(@url)
      request["accept"] = "application/json"
      request["content-type"] = "application/json"
      request["apikey"] = evo_token
      request.body = body
      @http.request(request)
    end

    private

    def evo_url
      ENV["EVO_URL"]
    end

    def evo_token
      ENV["EVO_TOKEN"]
    end

    def evo_instance
      ENV["EVO_INSTANCE"]
    end
  end
end
