module API::V1
  class Student::SubscriptionsController < ApplicationController
    InvalidHusbandError = Class.new(StandardError)
    InvalidWifeError = Class.new(StandardError)
    InvalidAddressError = Class.new(StandardError)

    def create
      husband = ::User.new(husband_params)
      wife = ::User.new(wife_params)
      address = ::Address.new(address_params)
      raise InvalidHusbandError unless husband.valid?
      raise InvalidWifeError unless wife.valid?
      raise InvalidAddressError unless address.valid?

      if husband.save && wife.save && address.save
        marriage = Marriage.new(
          husband: husband,
          wife: wife,
          address_id: address.id,
          registered_by: marriage_params[:registered_by],
          is_member: marriage_params[:is_member],
          campus: marriage_params[:campus],
          religion: marriage_params[:religion],
          reason: marriage_params[:reason],
          children_quantity: marriage_params[:children_quantity],
          days_availability: marriage_params[:days_availability]
        )
        if marriage.save
          render json: { marriage: marriage }, include: [ :husband, :wife, :address ], status: :created
        else
          render json: { error: marriage.errors.full_messages }, status: :unprocessable_entity
        end
      end
    rescue InvalidHusbandError => e
      render json: { error: husband.errors.full_messages }, status: :unprocessable_entity
    rescue InvalidWifeError => e
      render json: { error: wife.errors.full_messages }, status: :unprocessable_entity
    rescue InvalidAddressError => e
      render json: { error: address.errors.full_messages }, status: :unprocessable_entity
    rescue ActiveRecord::RecordInvalid => e
      render json: { error: e.record.errors.full_messages }, status: :unprocessable_entity
    rescue StandardError => e
      render json: { error: e.message }, status: :unprocessable_entity
    end

    def update
      marriage = ::Marriage.find(params[:id])
      # debugger
      marriage.husband.update(husband_params)
      marriage.wife.update(wife_params)
      marriage.address.update(address_params)
      if marriage.update(marriage_params)
        render json: { marriage: marriage }, include: [ :husband, :wife, :address ], status: :ok
      else
        render json: { errors: marriage.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def search
      marriage = ::Marriage.by_phone(params[:phone])
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
        :password,
        :password_confirmation
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
        :password,
        :password_confirmation
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
