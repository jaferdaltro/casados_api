module API::V1
  class User::RegistrationsController < ApplicationController
    def create
      user = ::User.new(registrations_params)

      if user.save
        render_json_with_success(status: :ok)
      else
        # debugger
        render_json_with_error(status: :unprocessable_entity, message: user.errors.full_messages)
      end
    end


    private

    def registrations_params
      params.require(:user).permit(:name, :phone, :email, :password, :password_confirmation)
    end
  end
end
