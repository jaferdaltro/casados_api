class Marriage < ApplicationRecord
  belongs_to :husband, class_name: "User"
  belongs_to :wife, class_name: "User"
  has_one :student_subscription
  has_one :address

  def self.create_marriage(husband_params, wife_params, marriage_params)
    transaction do
      husband = User.create!(husband_params)
      wife = User.create!(wife_params)
      marriage = ::Marriage.new(husband_id: husband.id,
                                wife_id: wife.id,
                                is_member: marriage_params[:is_member],
                                registered_by: marriage_params[:registered_by],
                                reason: marriage_params[:reason],
                                religion: marriage_params[:religion],
                                children_quantity: marriage_params[:children_quantity],
                                days_availability: marriage_params[:days_availability]
                              )
      marriage.save!
    end
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error("Erro ao criar o casamento: #{e.message}")
  end
end
