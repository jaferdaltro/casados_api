class Marriage < ApplicationRecord
  belongs_to :husband, class_name: "User"
  belongs_to :wife, class_name: "User"
  belongs_to :address

  has_one :student_subscription

  validates :husband_id, :wife_id, :is_member,
            :days_availability, presence: true

  validate :should_be_different_users

  def self.create_marriage(husband_params, wife_params, address_params, marriage_params)
    transaction do
      husband = User.create!(husband_params)
      wife = User.create!(wife_params)
      address = Address.create!(address_params)
      create!(
        uuid: SecureRandom.uuid,
        husband_id: husband.id,
        wife_id: wife.id,
        address_id: address.id,
        registered_by: marriage_params[:registered_by],
        is_member: marriage_params[:is_member],
        campus: marriage_params[:campus],
        religion: marriage_params[:religion],
        reason: marriage_params[:reason],
        children_quantity: marriage_params[:children_quantity],
        days_availability: marriage_params[:days_availability]
      )
    end
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error("Erro ao criar o casamento: #{e.message}")
  end

  private

  def should_be_different_users
    errors.add(:base, "Marido e esposa devem ser usuários diferentes") if husband_id == wife_id
  end
end
