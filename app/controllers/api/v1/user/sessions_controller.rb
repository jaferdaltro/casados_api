module API::V1
    class User::SessionsController < BaseController
      skip_before_action :authenticate_user!
      def create
        user = ::User.find_by_phone(params[:session][:phone])
        if user && user.authenticate(params[:session][:password])
          log_in(user)
          render_success(status: :ok)
        else
          render_error(status: :unauthorized, message: "Usuário ou senha invalidos")
        end
      end

      def destroy
        log_out
        render_success(status: :see_other)
      end

      private

      def user_params
        @user_params ||= params.require(:user).permit(:phone, :password)
      end
    end
end
