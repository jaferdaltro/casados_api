module API::V1
  class User::RegistrationsController < ApplicationController
    def create
      user = ::User.new(registrations_params)

      if user.save
        render_success(status: :ok)
      else
        render_error(status: :unprocessable_entity, message: user.errors.full_messages)
      end
    end


    private

    def registrations_params
      params.require(:user).permit(:name, :phone, :email, :cpf, :password, :password_confirmation)
    end
  end
end
