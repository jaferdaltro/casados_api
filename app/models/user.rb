class User < ApplicationRecord
  VALID_PHONE_REGEX = /\A\(?([0-9]{2})\)?[-. ]?([0-9]{4,5})[-. ]?([0-9]{4})\z/
  has_secure_password

  before_save { self.phone = phone.try(:delete, " ") }

  has_many :memberships, dependent: :destroy
  has_many :accounts, through: :memberships

  has_one :token, class_name: "UserToken", dependent: :destroy

  validates :phone, presence: true,
                    length: { is: 11 },
                    format: { with: VALID_PHONE_REGEX, message: "O número de telefone é inválido, ex: 85 99999 9999" },
                     uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }
  validates :name, presence: true, length: { minimum: 3, maximum: 50 }
end
