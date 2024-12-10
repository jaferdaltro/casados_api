FactoryBot.define do
  factory :user do
    name { Faker::DcComics.hero }
    phone { Faker::PhoneNumber.cell_phone }
    cpf { CPF.generate }
    email { Faker::Internet.email }
    password { "123456" }
    password_confirmation { "123456" }
    role { 0 }
    gender { "male" }
    t_shirt_size { "M" }
  end

  factory :husband, class: User do
    name { Faker::DcComics.hero }
    phone { Faker::PhoneNumber.cell_phone }
    cpf { CPF.generate }
    email { Faker::Internet.email }
    password { "123456" }
    password_confirmation { "123456" }
    role { 0 }
    gender { "male" }
    t_shirt_size { "M" }
  end

  factory :wife, class: User do
    name { Faker::DcComics.hero }
    phone { Faker::PhoneNumber.cell_phone }
    cpf { CPF.generate }
    email { Faker::Internet.email }
    password { "123456" }
    password_confirmation { "123456" }
    role { 0 }
    gender { "female" }
    t_shirt_size { "p" }
  end
end
