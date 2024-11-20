class Voucher < ApplicationRecord
  validates :code, presence: true, uniqueness: true

  def is_valide?(voucher)
    voucher.is_available && voucher.expiration_at >= DateTime.now
  end
end
