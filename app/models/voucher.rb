class Voucher < ApplicationRecord
  validates :code, presence: true, uniqueness: true

  def self.generate_code
    loop do
      code = SecureRandom.hex
      break code unless Voucher.exists?(code: code)
    end
  end
end
