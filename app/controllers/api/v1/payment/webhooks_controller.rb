module API::V1
  class Payment::WebhooksController < ApplicationController
    # skip_before_action :verify_authenticity_token

    def create
      # event = Event.create!(
      #   data: params,
      #   souce: params[:source]
      # )
      HandleEventJob.perform_later
      # render json: { status: :ok }
    end
  end
end
