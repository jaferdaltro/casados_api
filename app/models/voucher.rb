class Voucher < ApplicationRecord
  validates :code, presence: true, uniqueness: true

  def is_valid?
    is_available && expiration_at >= DateTime.now && has_life?
  end

  def has_life?
    lives > 0
  end
end
