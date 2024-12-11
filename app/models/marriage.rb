class Marriage < ApplicationRecord
  belongs_to :husband, class_name: "User"
  belongs_to :wife, class_name: "User"
  belongs_to :address

  has_one :student_subscription

  validates :husband_id, :wife_id, :is_member,
            :days_availability, presence: true

  validate :should_be_different_users

  scope :by_phone, ->(phone) { joins(:husband, :wife).where("husband.phone" => phone).or(Marriage.where("wife.phone" => phone)) }

  private

  def should_be_different_users
    errors.add(:base, "Marido e esposa devem ser usuários diferentes") if husband_id == wife_id
  end
end
