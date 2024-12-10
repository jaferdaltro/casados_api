FactoryBot.define do
  factory :voucher do
    code { "code" }
    is_available { true }
    expiration_at { Time.now + 1.day }
    user_id { 1 }
    lives { 1 }
  end
end
