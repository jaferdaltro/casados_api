class ApplicationController < ActionController::API
  # include ActionController::Cookies

  rescue_from ActionController::ParameterMissing do |exception|
    render_error(status: :bad_request, message: exception.message)
  end

  rescue_from StandardError do |exception|
    Rails.error.report(exception)
    render_error(status: :internal_server_error, message: exception.message)
  end

  protected

  # Sets a cookie
  # def set_user_cookie(user)
  #   cookies.encrypted[:user_id] = {
  #     value: user.id,
  #     expires: 1.day.from_now,
  #     httponly: true
  #   }
  # end

  # Remembers a user in a persistent session.
  # def remember(user)
  #   user.remember
  #   cookies.permanent.encrypted[:user_id] = user.id
  #   cookies.permanent[:remember_token] = user.remember_token
  # end

  def authenticate_user!
    return if current_user

    render_error(status: :unauthorized, message: "Não autorizado")
  end

  def logged_in?
    !current_user.nil?
  end

  def log_in(user)
    session[:user_id] = user.id
  end

  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  # def current_user
  #   if (user_id = session[:user_id])
  #     @current_user ||= User.find_by(id: user_id)
  #   elsif (user_id = cookies.encrypted[:user_id])
  #     user = User.find_by(id: user_id)
  #     if user && user.authenticated?(cookies[:remember_token])
  #       log_in user
  #       @current_user = user
  #     end
  #   end
  # end

  def render_success(status:)
    json = { status: :success }
    render status:, json:
  end

  def render_error(status:, message:, details: {})
    render status:, json: { status: :error, message:, details: }
  end

  def log_out
    reset_session
    @current_user = nil
  end

  # def render_json_with_record_errors(record)
  #   message = record.errors.full_messages.join(", ")
  #   details = record.errors.message

  #   render_error(status: :unprocessable_entity, message:, details:)
  # end
end
