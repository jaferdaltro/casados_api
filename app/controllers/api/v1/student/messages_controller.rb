module API::V1
  class Student::MessagesController < ApplicationController

    def create
      message = message_params.to_json
      Evo::Base.new.create(message)
      render json: { message: "Mensagem enviada com sucesso" }, status: :created
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end

    private

    def message_params
      return {} unless params.has_key?(:message)

      params.require(:message).permit(:number, :text)
    end
  end
end
