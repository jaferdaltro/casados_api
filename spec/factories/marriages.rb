FactoryBot.define do
  factory :marriage do
    husband
    wife
    address
    registered_by { Faker::DcComics.hero }
    is_member { true }
    campus { "campus" }
    religion { "religion" }
    reason { "reason" }
    children_quantity { 1 }
    days_availability { [ 1, 2, 3 ] }
  end
end
