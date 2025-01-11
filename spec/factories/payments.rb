FactoryBot.define do
  factory :payment do
    customer { nil }
    amount { "9.99" }
    payment_method { 1 }
    status { 1 }
    due_date { "2025-01-10" }
    asaas_payment_id { "MyString" }
    card_holder_name { "MyString" }
    card_number { "MyString" }
    card_expiry_month { "MyString" }
    card_expiry_year { "MyString" }
    card_cvv { "MyString" }
  end
end
