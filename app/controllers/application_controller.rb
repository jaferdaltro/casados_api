class ApplicationController < ActionController::API
  rescue_from ActionController::ParameterMissing do |exception|
    render_json_with_error(status: :bad_request, message: exception.message)
  end

  rescue_from StandardError do |exception|
    Rails.error.report(exception)

    message = Rails.env.production? ? "Erro interno" : exception.message

    render_json_with_error(status: :internal_server_error, message:)
  end

  protected

  def authenticate_user!
    return if current_user

    render_json_with_error(status: :unauthorized, message: "Não autorizado")
  end

  def current_user
    @current_user ||= authenticate_with_http_token do |access_token|
      User.joins(:token).find_by(user_tokens: { access_token: })
    end
  end

  def render_json_with_model_success(status:)
    json = { status: :success }
    render status:, json:
  end

  def render_json_with_model_errors(status:, messages:, details: {})
    # debugger
    render status:, json: { status: :error, messages:, details: }
  end

  def render_json_with_record_errors(record)
    message = record.errors.full_messages.join(", ")
    details = record.errors.messages

    render_json_with_error(status: :unprocessable_entity, message:, details:)
  end
end
