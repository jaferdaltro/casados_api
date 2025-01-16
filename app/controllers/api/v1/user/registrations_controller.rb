module API::V1
  class User::RegistrationsController < ApplicationController
    def create
      default_password = "123456"
      user = ::User.new(registrations_params.merge(password: default_password, password_confirmation: default_password))
      if user.save
        render json: { user: user }, status: :created
      else
        render_error(status: :unprocessable_entity, message: user.errors.full_messages)
      end
    end

    def update
      user = ::User.find(params[:id])
      if user.update(registrations_params)
        render json: { user: user }, status: :ok
      else
        render_error(status: :unprocessable_entity, message: user.errors.full_messages)
      end
    end

    def search
      users = ::User.find_by_phone(params[:phone])
      render json: { users: users }, status: :ok
    rescue ActiveRecord::RecordNotFound => e
      render json: { error: e.message }, status: :not_found
    end


    private

    def registrations_params
      params.require(:user).permit(:name, :phone, :email, :cpf, :role, :birth_at, :gender, :password, :password_confirmation)
    end
  end
end
