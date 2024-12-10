class Voucher < ApplicationRecord
  validates :code, presence: true, uniqueness: true
  validates :user_id, :expiration_at, :is_available, :lives, presence: true

  validate :voucher_should_be_available, :voucher_should_not_be_expired, :voucher_should_have_life

  private
    def voucher_should_be_available
      errors.add(:is_available, "Voucher indisponivel") unless is_available
    end

    def voucher_should_not_be_expired
      return if expiration_at.nil?

      errors.add(:expiration_at, "Voucher expirado") unless expiration_at >= DateTime.now
    end

    def voucher_should_have_life
      return if lives.nil?

      errors.add(:lives, "Voucher sem vida") unless lives > 0
    end
end
