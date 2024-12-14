module API::V1
  class User::RegistrationsController < ApplicationController
    def create
      user = ::User.new(registrations_params)

      if user.save
        render json: { user: user }, status: :created
      else
        render_error(status: :unprocessable_entity, message: user.errors.full_messages)
      end
    end

    def update
      user = ::User.find(params[:id])
      if user.update(registrations_params)
        render json: { user: user }, status: :created
      else
        render_error(status: :unprocessable_entity, message: user.errors.full_messages)
      end
    end


    private

    def registrations_params
      params.require(:user).permit(:name, :phone, :email, :cpf, :role, :birth_at, :gender, :password, :password_confirmation)
    end
  end
end
