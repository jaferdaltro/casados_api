module API::V1
  class Student::SubscriptionsController < ApplicationController
    include Paginable

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
          address: address,
          registered_by: marriage_params[:registered_by],
          is_member: marriage_params[:is_member],
          dinner_participation: marriage_params[:dinner_participation],
          active: marriage_params[:active],
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
      marriage = Marriage.find_by(id: params[:id])
      return render json: { error: "Marriage not found" }, status: :not_found unless marriage

      Marriage.transaction do
        begin
          marriage.husband.update!(husband_params)
          marriage.wife.update!(wife_params)
          marriage.address&.update!(address_params) || marriage.create_address(address_params)
          marriage.update!(marriage_params)

          render json: {
            marriage: marriage,
            include: [ :husband, :wife, :address ]
          }, status: :ok
        rescue ActiveRecord::RecordInvalid => e
          render json: {
            errors: e.record.errors.full_messages
          }, status: :unprocessable_entity
        end
      end
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
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
      # marriages = ::Marriage.all

      # marriages = marriages.by_name(params[:name]) if params[:name].present?
      # marriages = marriages.by_dinner_participation(params[:dinner_participation]) if params[:dinner_participation].present?
      marriages = search_records
      marriages = marriages.includes(:husband, :wife, :address)
                            .page(current_page)
                            .per(per_page)

      render json: marriages,
             meta: meta_attributes(marriages),
             only: %i[id registered_by dinner_participation reason
                       children_quantity days_availability is_member
                       campus religion active],
             include: {
               husband: { only: %i[name phone email birth_at cpf role] },
               wife: { only: %i[name phone email birth_at cpf role] },
               address: { only: %i[street number neighborhood city state cep] }
             },
             root: true,
             status: :ok
    end

    private

    def search_records
      records = ::Marriage.all
      return records unless params.has_key?(:search)

      search_params = params.require(:search).permit(:name, :dinner_participation)

      search_params.each do |name|
        records = records.by_name(name) if params[:search][:name].present?
        records = records.by_dinner_participation(name) if params[:search][:dinner_participation].present?
      end
      records
    end

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
        :role,
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
        :role,
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
        :dinner_participation,
        :campus,
        :religion,
        :active,
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
