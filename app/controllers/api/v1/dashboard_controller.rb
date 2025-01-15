module API::V1
  class DashboardController < BaseController
    def index
      active_leaders = Marriage.active_leaders.count
      active_co_leaders = Marriage.active_co_leaders.count
      active_students = Marriage.active_students.count
      active_classrooms = Classroom.active.count
      inactive_students = Marriage.inactive_students.count
      sended_messages = Message.sended.count

      render json: {
                      active_students: active_students,
                      active_leaders: active_leaders,
                      active_co_leaders: active_co_leaders,
                      active_classrooms: active_classrooms,
                      inactive_students: inactive_students,
                      sended_messages: sended_messages
                    }, status: :ok
    end

    def active_students
    end
  end
end
