class Marriage < ApplicationRecord
  belongs_to :husband, class_name: "User"
  belongs_to :wife, class_name: "User"
  belongs_to :address, optional: true

  has_many :classroom_students
  has_many :classrooms, through: :classroom_students
  has_many :payments

  has_one :student_subscription

  validates :husband_id, :wife_id,  presence: true

  validate :should_be_different_users

  scope :by_phone, ->(phone) { joins(:husband, :wife).where("husband.phone" => phone).or(Marriage.where("wife.phone" => phone)) }
  scope :by_cpf, ->(cpf) { joins(:husband, :wife).where("husband.cpf" => cpf).or(Marriage.where("wife.cpf" => cpf)) }

  scope :by_name, ->(name) {
    joins("INNER JOIN users AS husbands ON husbands.id = marriages.husband_id")
    .joins("INNER JOIN users AS wives ON wives.id = marriages.wife_id")
    .where("husbands.name ILIKE :name OR wives.name ILIKE :name", name: "%#{name}%")
  }

  scope :by_role, ->(role) {
    joins("INNER JOIN users AS husbands ON husbands.id = marriages.husband_id")
    .joins("INNER JOIN users AS wives ON wives.id = marriages.wife_id")
    .where("husbands.role = ? OR wives.role = ?", role, role)
  }

  scope :by_dinner_participation, ->(dinner_participation) { where(dinner_participation: dinner_participation) }
  scope :by_pastoral_indication, ->(pastoral_indication) { where(pastoral_indication: pastoral_indication) }


  private

  def should_be_different_users
    errors.add(:base, "Marido e esposa devem ser usuários diferentes") if husband_id == wife_id
  end
end
