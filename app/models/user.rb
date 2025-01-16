class User < ApplicationRecord
  VALID_PHONE_REGEX = /\A\(?([0-9]{2})\)?[-. ]?([0-9]{4,5})[-. ]?([0-9]{4})\z/
  has_secure_password

  has_many :marriages_as_husband, class_name: "Marriage", foreign_key: "husband_id"
  has_many :marriages_as_wife, class_name: "Marriage", foreign_key: "wife_id"
  has_many :messages_as_sender, class_name: "Message", foreign_key: "sender_id"
  has_many :messages_as_receiver, class_name: "Message", foreign_key: "receiver_id"

  has_one :membership, dependent: :destroy

  has_one :token, class_name: "UserToken", dependent: :destroy

  validates :name, presence: true
  validates :phone, presence: true,
                    length: { is: 11 },
                    format: { with: VALID_PHONE_REGEX, message: "O número de telefone é inválido, ex: 85 99999 9999" },
                     uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }
  validates :cpf, uniqueness: true, if: -> { cpf.present? }

  validate :user_should_have_correct_cpf

  normalizes :phone, with: -> { _1.tr("()", "").tr("-", "").gsub(/\s+/, "") }
  normalizes :cpf, with: -> { _1.gsub(/[.-]/, "") }

  scope :by_name, ->(name) { where(name: name) }

  enum :role, [ :student, :co_leader, :leader, :coordinator ], prefix: true, default: :student

  enum :gender, [ :male, :female ], prefix: true

  def is_coordinator?
    role == "coordinator"
  end

  # Returns true if the given token matches the digest.
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end

  private

  def user_should_have_correct_cpf
    return if cpf.blank?

    errors.add(:cpf, "CPF inválido") unless CPF.valid?(cpf)
  end
end
