module API::V1
  class ClassroomsController < BaseController
    InvalidAddressError = Class.new(StandardError)

    def create
      ActiveRecord::Base.transaction do
        address = ::Address.create!(address_params)
        raise InvalidAddressError unless address.valid?
        classroom = Classroom.new(classroom_params.merge(address_id: address.id))

        if classroom.save
          render json: {
            message: "Classroom created successfully",
            data: {
              classroom: classroom
            }
          },
          include: [ :leader_marriage, :co_leader_marriage, :address ],
          status: :created
        else
          render json: {
            error: classroom.errors.full_messages
          }, status: :unprocessable_entity
        end
      end
    rescue InvalidAddressError => e
      render json: { error: e.errors.full_messages }, status: :unprocessable_entity
    rescue ActiveRecord::RecordInvalid => e
      render json: { error: e.record.errors.full_messages }, status: :unprocessable_entity
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end

    private

    def classroom_params
      params.require(:classroom).permit(
        :leader_marriage_id,
        :co_leader_marriage_id,
        :weekday,
        :class_time
      )
    end

    def address_params
      return {} unless params.has_key?(:address)

      params.require(:address).permit(:street, :number, :neighborhood, :city, :state, :cep)
    end
  end
end
