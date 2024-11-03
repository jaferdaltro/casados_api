class RegistrationsController < ApplicationController
  def create
    user = User.new(registrations_params)

    if user.save
      render_json_with_model_success(status: :ok)
    else
      # debugger
      render_json_with_model_errors(status: :unprocessable_entity, messages: user.errors.full_messages)
    end
  end


  private

  def registrations_params
    params.require(:user).permit(:name, :phone, :email, :password, :password_confirmation)
  end
end
