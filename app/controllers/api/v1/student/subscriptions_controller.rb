module API::V1
  class Student::SubscriptionsController < ApplicationController
    include Paginable

    InvalidHusbandError = Class.new(StandardError)
    InvalidWifeError = Class.new(StandardError)
    InvalidAddressError = Class.new(StandardError)
    MarriageNotFoundError = Class.new(StandardError)

    def create
      ActiveRecord::Base.transaction do
        husband = ::User.create!(husband_params)
        wife = ::User.create!(wife_params)
        address = ::Address.create!(address_params)

        marriage = Marriage.new(
          husband: husband,
          wife: wife,
          address: address,
          registered_by: marriage_params[:registered_by] || current_user&.name,
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
          Rails.logger.info("[Subscription Create] Marriage created: #{marriage&.id} for husband: #{husband&.id} and wife: #{wife&.id} by #{current_user&.id}")
          render json: { marriage: marriage }, include: [ :husband, :wife, :address ], status: :created
        else
          raise ActiveRecord::RecordInvalid.new(marriage)
        end
      end
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.warn("[Subscription Create] Fail to process marriage creation: #{e.record.errors.full_messages}")
      render json: { error: e.record.errors.full_messages }, status: :unprocessable_entity
    rescue StandardError => e
      Rails.logger.warn("[Subscription Create] Fail to process marriage creation: #{e.message}")
      render json: { error: e.message }, status: :internal_server_error
    end

    def update
      marriage = Marriage.find_by(id: params[:id])
      return render json: { error: "Marriage not found" }, status: :not_found unless marriage

      Marriage.transaction do
        begin
          marriage.husband.update!(husband_params)
          marriage.wife.update!(wife_params)
          marriage.address_id.nil? ? marriage.create_address(address_params) : marriage.address&.update!(address_params)
          marriage.update!(marriage_params)

          Rails.logger.info("[Subscription Update] Marriage updated: #{marriage.id}")
          render json: { marriage: marriage }, status: :ok
        rescue ActiveRecord::RecordInvalid => e
          Rails.logger.warn("[Subscription update] Fail to process marriage update: #{e.record.errors.full_messages}")
          render json: {
            errors: e.record.errors.full_messages
          }, status: :unprocessable_entity
        end
      end
    rescue StandardError => e
      Rails.logger.warn("[Subscription update] Fail to process marriage update: #{e.message}")
      render json: { error: e.message }, status: :internal_server_error
    end

    def search
      marriage = ::Marriage.find_by_uuid(params[:uuid])
      marriage ||= ::Marriage.by_phone(params[:phone])
      raise MarriageNotFoundError unless marriage
      render json: marriage, include: [ :husband, :wife, :address ],
      fields: { marriage: [
        :id,
        :registered_by,
        :dinner_participation,
        :pastoral_indication,
        :reason,
        :children_quantity,
        :days_availability,
        :is_member,
        :campus,
        :religion,
        :active] }, root: true, status: :ok
    rescue MarriageNotFoundError => e
      render json: { error: e.message }, status: :not_found
    rescue ActiveRecord::RecordNotFound => e
      render json: { error: e.message }, status: :not_found
    rescue
    end

    def index
      marriages = search_records
      marriages = marriages.includes(:husband, :wife, :address)
                            .page(current_page)
                            .per(per_page)

      render json: marriages,
             meta: meta_attributes(marriages),
             only: %i[id registered_by dinner_participation pastoral_indication reason
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
      records = Marriage.all
      return records unless search_params.present?

      scope = records
      scope = scope.by_name(search_params[:name]) if search_params[:name].present?
      scope = scope.by_cpf(search_params[:cpf]) if search_params[:cpf].present?
      scope = scope.by_role(parametrize_role) if search_params[:role].present?
      scope = scope.by_phone(search_params[:phone]) if search_params[:phone].present?
      scope = scope.by_dinner_participation(search_params[:dinner_participation]) if search_params[:dinner_participation].present?
      scope = scope.by_pastoral_indication(search_params[:pastoral_indication]) if search_params[:pastoral_indication].present?

      scope.page(params[:page]).per(params[:per_page] || 10)
    rescue ActionController::ParameterMissing => e
      render json: { error: e.message }, status: :bad_request
    rescue StandardError => e
      render json: { error: "An error occurred while searching" }, status: :internal_server_error
    end

    def parametrize_role
      role = search_params[:role]
      case role
      when "student" then 0
      when "co_leader" then 1
      when "leader" then 2
      when "coordinator" then 3
      else 0
      end
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
        :husband,
        :wife,
        :address,
        :is_member,
        :dinner_participation,
        :pastoral_indication,
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

    def search_params
      @search_params ||= params.fetch(:search, {}).permit(:name, :cpf, :role, :dinner_participation, :pastoral_indication)
    end
  end
end
