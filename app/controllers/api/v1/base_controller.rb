module API::V1
  class BaseController < ApplicationController
    include ActionController::HttpAuthentication::Token::ControllerMethods

    before_action :authenticate_user!
  end
end
