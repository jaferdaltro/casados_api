module Voucher::Generate
  def self.list(user_id, amount)
    vouchers = []
    amount.times do
      vouchers << create(user_id)
    end
    vouchers
  end

  private

  def self.create_code(user_id, days: 1, lives: 1)
    code = generate_code
    Voucher.create(
      code: code,
      is_available: true,
      expiration_at: Time.now + days.days,
      user_id: user_id,
      lives: lives
    )
  end
  def self.generate_code
    loop do
      code = SecureRandom.hex
      break code unless Voucher.exists?(code: code)
    end
  end
end
