module Voucher::Generate
  def self.list(user_id, amount)
    vouchers = []
    amount.times do
      vouchers << create(user_id)
    end
    vouchers
  end

  private

  def self.create(user_id)
    code = generate_code
    Voucher.create(
      code: code,
      is_available: true,
      expiration_at: Time.now + 3.days,
      user_id: user_id
    )
  end
  def self.generate_code
    loop do
      code = SecureRandom.hex
      break code unless Voucher.exists?(code: code)
    end
  end
end
