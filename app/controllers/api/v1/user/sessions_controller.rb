module API::V1
    class User::SessionsController < BaseController
      # skip_before_action :authenticate_user!
      def create
        user = ::User.find_by(cpf: params[:session][:cpf])
        if user && user.authenticate(params[:session][:password])
          # reset_session
          # remember user
          log_in user
          render json: { user: user }, status: :ok
        else
          render_error(status: :unauthorized, message: "Usuário ou senha inválidos")
        end
      end

      def destroy
        log_out if logged_in?
        render_success(status: :see_other)
      end
    end
end
