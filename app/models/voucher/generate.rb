module Voucher::Generate
  def self.list(user_id, amount, lives)
    Array.new(amount) { create_code(user_id, lives: lives) }
  end

  private

  def self.create_code(user, lives:)
    code = SecureRandom.hex
    Voucher.create!(
      code: code,
      is_available: true,
      expiration_at: (Time.now + 1.day),
      user_id: user,
      lives: lives
    )
  rescue ActiveRecord::RecordInvalid => exception
    puts "Erro ao criar o voucher: #{exception.record.errors.full_messages}"
  end

  def self.generate_code
  end
end
