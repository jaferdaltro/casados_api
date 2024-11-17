class Marriage < ApplicationRecord
  belongs_to :husband, class_name: "User"
  belongs_to :wife, class_name: "User"
  has_one :student_subscription
  has_one :address

  def self.create_marriage(husband_params, wife_params, marriage_params)
    transaction do
      husband = User.new(husband_params)
      wife = User.new(wife_params)
      if husband.save && wife.save
        husband_id = husband.id
        wife_id = wife.id
      else
       errors.add(:user, "algua coisa errada no usuário")
      end
      marriage = ::Marriage.new(husband_id: husband_id,
                                wife_id: wife_id,
                                is_member: marriage_params[:is_member],
                                registred_by: marriage_params[:registred_by],
                                reason: marriage_params[:reason],
                                religion: marriage_params[:religion],
                                children_quantity: marriage_params[:children_quantity],
                                days_availability: marriage_params[:days_availability]
                              )
      marriage.save!
    end
  end
end
