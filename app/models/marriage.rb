class Marriage < ApplicationRecord
  belongs_to :husband, class_name: "User"
  belongs_to :wife, class_name: "User"
  has_one :student_subscription
  has_one :address

  validates :husband_id, :wife_id, :is_member, :campus, :religion, :reason,
            :registered_by, :children_quantity, :days_availability, presence: true

  validate :different_users

  def self.create_marriage(husband_params, wife_params, marriage_params)
    transaction do
      husband = User.create!(husband_params)
      wife = User.create!(wife_params)

      create!(
        husband_id: husband.id,
        wife_id: wife.id,
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
    raise # Re-raise para permitir tratamento no controlador
  end

  private

  def different_users
    if husband_id == wife_id
      errors.add(:base, "Marido e esposa devem ser usuários diferentes")
    end
  end
end
