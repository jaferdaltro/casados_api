module API::V1
  class VouchersController < BaseController
    def create
      code = Voucher.generate_code
      voucher = ::Voucher.create!(
        code: code,
        is_available: true,
        expiration_at: Time.now + 3.days,
        user_id: current_user.id
      )
      render json: voucher
    end

    private

    def voucher_params
      params.require(:voucher).permit(:code)
    end
  end
end
