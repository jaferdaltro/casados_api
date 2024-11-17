class Voucher < ApplicationRecord
  validates :code, presence: true, uniqueness: true

  def self.generate_code
    loop do
      code = SecureRandom.hex
      break code unless Voucher.exists?(code: code)
    end
  end

  def self.is_valide?(voucher)
    voucher.is_available && voucher.expiration_at >= DateTime.now
  end
end
