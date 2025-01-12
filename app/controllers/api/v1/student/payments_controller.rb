module API::V1
  class Student::PaymentsController < ApplicationController
    before_action :set_client

    def create_pix
     CreateClientJob.perform_now(params[:marriage_uuid])
     payload = nil
     count = 0
     while payload.nil? || count == 10 do
      payload = @client.payments&.last.qr_code
      count += 1
      sleep 1
     end
     unless payload.nil?
      render json: { pix: payload }, status: :created
     else
      render json: { error: "Não foi possível criar a chave PIX" }, status: :unprocessable_entity
     end
    end

    private

    def set_size
      ActiveRecord::Base.transaction do
        @client.husband.update_attribute(:t_shirt_size, husband_size_params)
        @client.wife.update_attribute(:t_shirt_size, wife_size_params)
      end
    rescue ActiveRecord::RecordNotFound => e
      Rails.logger.error("[Create Client] - Client not found")
    rescue StandardError => e
      Rails.logger.error("[Create Client] - Error: #{e}")
    end

    def set_client
      @client = Marriage.find_by_uuid(params[:marriage_uuid])
    rescue ActiveRecord::RecordNotFound
      Rails.logger.error("[Create PIX Job] - Client not found")
    end

    def husband_size_params
      return {} unless params[:husband_size]

      params.require(:husband_size).permit(:P, :M, :G, :GG, :XG)
    end

    def wife_size_params
      return {} unless params[:wife_size]

      params.require(:wife_size).permit(:P, :M, :G, :GG, :XG)
    end
  end
end
