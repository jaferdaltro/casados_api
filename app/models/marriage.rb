class Marriage < ApplicationRecord
  belongs_to :husband, class_name: "User"
  belongs_to :wife, class_name: "User"
  belongs_to :address, optional: true

  has_one :student_subscription

  validates :husband_id, :wife_id,  presence: true

  validate :should_be_different_users

  scope :by_phone, ->(phone) { joins(:husband, :wife).where("husband.phone" => phone).or(Marriage.where("wife.phone" => phone)) }
  scope :by_name, ->(name) { joins(:husband, :wife).where("husband.name" => name).or(Marriage.where("wife.name" => name)) }

  private

  def should_be_different_users
    errors.add(:base, "Marido e esposa devem ser usuários diferentes") if husband_id == wife_id
  end
end
