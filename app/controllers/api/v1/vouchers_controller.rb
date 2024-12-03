module API::V1
  class VouchersController < BaseController
    def create
      return unless current_user.is_coordinator?

      vouchers = Voucher::Generate.list(current_user.id, params[:amount], params[:lives])

      render json: vouchers
    end
  end
end
