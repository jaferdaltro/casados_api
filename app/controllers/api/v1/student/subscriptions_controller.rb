module API::V1
  class Student::SubscriptionsController < ApplicationController
    def edit
      couple_phone = husband_params[:phone] || wife_params[:phone]
      marriage = ::Marriage.find_by_phone(couple_phone)
      render json: marriage,
      include: [ :husband, :wife ],
      fields: { marriages: [ :id, :is_member, :registered_by, :reason ] }
    rescue ActiveRecord::RecordNotFound => e
      render json: { error: e.message }, status: :not_found
    end

    def create
      begin
        @marriage = Marriage.create_marriage(
          husband_params,
          wife_params,
          address_params,
          marriage_params
        )
        render json: { marriage: @marriage }, status: :created
      rescue ActiveRecord::RecordInvalid => e
        render json: { error: e.message }, status: :unprocessable_entity
      end
    end

    def search
      marriage = ::Marriage.find_by_phone(params[:phone])
      render json: marriage,
      include: [ :husband, :wife, :address ],
      fields: { marriages: [ :id, :is_member, :registered_by, :reason ] }
    rescue ActiveRecord::RecordNotFound => e
      render json: { error: e.message }, status: :not_found
    end

    def index
      render json: ::Marriage.all,
      include: [ :husband, :wife ],
      fields: { marriages: [ :id, :is_member, :registered_by, :reason ] }
    end

    private

    def voucher
      ::Voucher.find_by(code: voucher_params[:code])
    end

    def address_params
      return {} unless params.has_key?(:address)

      params.require(:address).permit(:street, :number, :neighborhood, :city, :state, :cep)
    end

    def husband_params
      return {} unless params.has_key?(:husband)

      @husband_params ||= params.require(:husband).permit(
        :name,
        :phone,
        :cpf,
        :email,
        :birth_at,
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
      ).with_defaults(
        password: "123456",
        password_confirmation: "123456"
      )
    end

    def marriage_params
      return {} unless params.has_key?(:marriage)

      @marriage_params ||= params.require(:marriage).permit(
        :registered_by,
        :is_member,
        :campus,
        :religion,
        :reason,
        :children_quantity,
        days_availability: []
      )
    end

    def voucher_params
      return {} unless params.has_key?(:voucher)

      @voucher_params ||= params.require(:voucher).permit(:code)
    end
  end
end
