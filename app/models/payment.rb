class Payment < ApplicationRecord
  belongs_to :marriage

  enum payment_method: [ :PIX, :CREDIT_CARD, :BANK_SLIP ]
end
