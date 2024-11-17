module API::V1
  class VouchersController < BaseController
    def create
      return unless current_user.is_coordinator?

      code = Voucher.generate_code
      voucher = ::Voucher.create!(
        code: code,
        is_available: true,
        expiration_at: Time.now + 3.days,
        user_id: current_user.id
      )
      render json: voucher
    end
  end
end
