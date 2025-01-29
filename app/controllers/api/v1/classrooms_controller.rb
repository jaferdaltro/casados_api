module API::V1
  class ClassroomsController < BaseController
    InvalidAddressError = Class.new(StandardError)

    def create
      leader_marriage = Marriage.find(classroom_params[:leader_marriage_id])
      return render json: { message: "Turma já cadastrada nesse semestre!" },
          status: :unprocessable_entity if leader_marriage.leader_classrooms.where(semester: "2025.1").exists?

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

    def update
      classroom = Classroom.find_by(id: params[:id])
      return render json: { error: "Classroom not found" }, status: :not_found unless classroom

      ActiveRecord::Base.transaction do
        address = classroom.address
        address.update!(address_params) if address_params.present? && address.present?

        if classroom.update(classroom_params)
          render json: {
            message: "Classroom updated successfully",
            data: classroom.as_json(
              include: {
                leader_marriage: { include: [ :husband, :wife ] },
                co_leader_marriage: { include: [ :husband, :wife ] },
                address: {}
              }
            )
          }, status: :ok
        else
          render json: {
            error: classroom.errors.full_messages
          }, status: :unprocessable_entity
        end
      end
    rescue ActiveRecord::RecordInvalid => e
      render json: { error: e.record.errors.full_messages }, status: :unprocessable_entity
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end

    def index
      classrooms = Classroom.includes(:leader_marriage, :co_leader_marriage, :address)
      classrooms = classrooms.where(leader_marriage_id: params[:leader_marriage_id]) if params[:leader_marriage_id].present?
      classrooms = classrooms.where(co_leader_marriage_id: params[:co_leader_marriage_id]) if params[:co_leader_marriage_id].present?
      classrooms = classrooms.page(params[:page]).per(params[:per_page] || 10)

      render json: classrooms.as_json(
        include: {
          leader_marriage: { include: [ :husband, :wife ] },
          co_leader_marriage: { include: [ :husband, :wife ] },
          address: {}
        }
      ), status: :ok
    end

    private

    def classroom_params
      return {} unless params[:classroom].present?

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
