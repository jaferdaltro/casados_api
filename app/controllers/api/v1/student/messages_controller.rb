module API::V1
  class Student::MessagesController < ApplicationController
    before_action :set_receiver, only: :create
    before_action :current_user, only: :create

    def create
      message = message_params.to_json
      Evo::Base.new.create(message)
      ::Message.create!(description: message, sender_id: current_user.id, receiver_id: @receiver&.id, sended: true)
      set_marriage_message
      Rails.logger.info("[Message Create] Message created: #{message}" \
        " for receiver: #{@receiver&.id} and sender: #{current_user&.id}")

      render json: {
        sended_message: true
        }, status: :created
    rescue ActiveRecord::RecordInvalid => e
      render json: { error: e.record.errors.full_messages }, status: :unprocessable_entity
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end

    private

    def message_params
      return {} unless params.has_key?(:message)

      params.require(:message).permit(:number, :text)
    end

    def set_receiver
      @receiver ||= ::User.find_by(phone: message_params[:number])

    rescue ActiveRecord::RecordNotFound => e
      render json: { error: e.record.errors.full_message }, status: :not_found
    end

    def set_marriage_message
      marriage = ::Marriage.find_by(husband_id: @receiver.id)
      marriage.update_attribute(:messaged, true)
    end
  end
end
