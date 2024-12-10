FactoryBot.define do
  factory :address do
    street { "street" }
    number { 1 }
    neighborhood { "neighborhood" }
    cep { "cep" }
    city { "city" }
    state { "state" }
  end
end
