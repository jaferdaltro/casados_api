class Marriage < ApplicationRecord
  belongs_to :husband, class_name: "User"
  belongs_to :wife, class_name: "User"
  belongs_to :address, optional: true

  has_one :student_subscription

  validates :husband_id, :wife_id,  presence: true

  validate :should_be_different_users

  scope :by_phone, ->(phone) { joins(:husband, :wife).where("husband.phone" => phone).or(Marriage.where("wife.phone" => phone)) }

  scope :by_name, ->(name) do
  joins("INNER JOIN users AS husbands ON husbands.id = marriages.husband_id")
    .joins("INNER JOIN users AS wives ON wives.id = marriages.wife_id")
    .where("husbands.name ILIKE :name OR wives.name ILIKE :name", name: "%#{name}%")
  end

  scope :by_dinner_participation, ->(dinner_participation) { where(dinner_participation: dinner_participation) }


  private

  def should_be_different_users
    errors.add(:base, "Marido e esposa devem ser usuários diferentes") if husband_id == wife_id
  end
end
