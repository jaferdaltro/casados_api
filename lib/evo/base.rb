require "uri"
require "net/http"

module Evo
  class Base
    def initialize
      @url = URI.parse(evo_url)
      @http = Net::HTTP.new(@url.host, @url.port)
      @http.use_ssl = true
    end

    def create(body)
      request = Net::HTTP::Post.new(@url)
      request["Content-Type"] = "application/json"
      request["Authorization"] = authorization

      # Parse body if it's a string
      message_data = body.is_a?(String) ? JSON.parse(body) : body

      # Structure the payload
      payload = {
        number: message_data["number"],
        body: message_data["body"]
      }

      request.body = payload.to_json

      response = @http.request(request)

      unless response.is_a?(Net::HTTPSuccess)
        Rails.logger.error("EVO API Error: #{response.code} - #{response.body}")
        raise "API request failed: #{response.message}"
      end

      response
    rescue JSON::ParserError => e
      Rails.logger.error("JSON parsing error: #{e.message}")
      raise "Invalid message format: #{e.message}"
    rescue StandardError => e
      Rails.logger.error("EVO API Error: #{e.message}")
      raise e
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

    def authorization
      ENV["EVO_AUTHORIZATION"]
    end
  end
end
