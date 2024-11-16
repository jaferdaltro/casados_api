module API::V1
  class Student::SubscriptionsController < ApplicationController
    def create
      if voucher_params.has_key?(:code)
       create_marriage
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

    def create_marriage
      husband = ::User.new(husband_params)
      wife = ::User.new(wife_params)
      if husband.save && wife.save
        husband_id = husband.id
        wife_id = wife.id
      else
        return render_json_with_error(status: :unprocessable_entity, message: [ husband.errors.full_messages, wife.errors.full_messages ].flatten)
      end
      is_member = marriage_params[:is_member]
      registred_by = marriage_params[:registred_by]
      reason = marriage_params[:reason]
      marriage = ::Marriage.new(husband_id: husband_id, wife_id: wife_id, is_member: is_member, registred_by: registred_by, reason: reason)
      if marriage.save
        render_json_with_success(status: :ok)
      else
        render_json_with_error(status: :unprocessable_entity, message: marriage.errors.full_messages)
      end
    end

    def build_user(params)
      # student_password = "123456"
      # password = { password: student_password, password_confirmation: student_password }
      # user = ::User.new(params.merge(password))
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

      @marriage_params ||= params.require(:marriage).permit(:is_member, :registred_by, :reason)
    end

    def voucher_params
      return {} unless params.has_key?(:voucher)

      @voucher_params ||= params.require(:voucher).permit(:code)
    end
  end
end
