class User < ApplicationRecord
  VALID_PHONE_REGEX = /\A\(?([0-9]{2})\)?[-. ]?([0-9]{4,5})[-. ]?([0-9]{4})\z/
  has_secure_password

  has_one :marriage, foreign_key: :wife_id, dependent: :destroy
  has_one :membership, dependent: :destroy

  has_one :token, class_name: "UserToken", dependent: :destroy

  validates :phone, presence: true,
                    length: { is: 11 },
                    format: { with: VALID_PHONE_REGEX, message: "O número de telefone é inválido, ex: 85 99999 9999" },
                     uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }

  normalizes :phone, with: -> { _1.tr("()", "").tr("-", "").gsub(/\s+/, "") }

  scope :find_by_phone, ->(phone) { find_by(phone: phone) }

  enum :role, %i[ student co_leader leader coordinator ], prefix: true, default: :student

  def is_coordinator?
    role == "coordinator"
  end
end
