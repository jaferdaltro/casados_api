class User < ApplicationRecord
  VALID_PHONE_REGEX = /\A\(?([0-9]{2})\)?[-. ]?([0-9]{4,5})[-. ]?([0-9]{4})\z/
  has_secure_password

  after_initialize :insert_password

  has_one :marriage, foreign_key: :wife_id, dependent: :destroy
  has_one :membership, dependent: :destroy

  has_one :token, class_name: "UserToken", dependent: :destroy

  validates :name, presence: true
  validates :phone, presence: true,
                    length: { is: 11 },
                    format: { with: VALID_PHONE_REGEX, message: "O número de telefone é inválido, ex: 85 99999 9999" },
                     uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }
  validates :cpf, uniqueness: true

  validate :user_should_have_correct_cpf

  normalizes :phone, with: -> { _1.tr("()", "").tr("-", "").gsub(/\s+/, "") }

  scope :find_by_phone, ->(phone) { find_by(phone: phone) }

  scope :find_by_cpf, ->(cpf) { find_by(cpf: cpf) }

  enum :role, [ :student, :co_leader, :leader, :coordinator ], prefix: true, default: :student

  enum :gender, [ :male, :female ], prefix: true

  def is_coordinator?
    role == "coordinator"
  end

  private

  def insert_password
    self.password ||= "123456"
  end

  def user_should_have_correct_cpf
    errors.add(:cpf, "CPF inválido") unless CPF.valid?(cpf)
  end
end
