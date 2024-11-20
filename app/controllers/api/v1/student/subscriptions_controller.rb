module API::V1
  class Student::SubscriptionsController < ApplicationController
    def create
      if Voucher.is_valide?(voucher)
       ::Marriage.create_marriage(husband_params, wife_params, marriage_params)
       charge = GenerateQrCodeJob.perform_now if is_pix?
       render json: charge, status: :ok
      else
        render_json_with_error(status: :unprocessable_entity, message: "Voucher inválido")
      end
    end

    def index
      render json: ::Marriage.all,
      include: [ :husband, :wife ],
      fields: { marriages: [ :id, :is_member, :registred_by, :reason ] }
    end

    private

    def voucher
      ::Voucher.find_by(code: voucher_params[:code])
    end

    def is_pix?
      params[:payment][:pix]
    end

    def credit_card
    end

    def create_charge
      if is_pix?
        pix
      elsif is_credit_card?
        # TODO
      else
        debugger
        render_json_with_error(status: :unprocessable_entity, message: "Pagamento inválido")
      end
    end

    def build_user(params)
      user = ::User.new(params)
      user.valid?
    end

    def husband_params
      return {} unless params.has_key?(:husband)

      @husband_params ||= params.require(:husband).permit(
        :name,
        :phone,
        :cpf,
        :email,
        :birth_at,
        :tshirt_size
      ).with_defaults(
          password: "123456",
          password_confirmation: "123456"
        )
    end

    def wife_params
      return {} unless params.has_key?(:wife)

      @wife_params ||= params.require(:wife).permit(
        :name,
        :phone,
        :cpf,
        :email,
        :birth_at,
        :tshirt_size
      ).with_defaults(
        password: "123456",
        password_confirmation: "123456"
      )
    end

    def marriage_params
      return {} unless params.has_key?(:marriage)

      @marriage_params ||= params.require(:marriage).permit(
        :is_member,
        :registred_by,
        :religion,
        :reason,
        :children_quantity,
        days_availability: []
      ).with_defaults(active: false)
    end

    def voucher_params
      return {} unless params.has_key?(:voucher)

      @voucher_params ||= params.require(:voucher).permit(:code)
    end

    def payment_param
      return {} unless params.has_key?(:payment)

      @payment_params ||= params.require(:payment).permit(:pix, :credit_card)
    end
  end
end
