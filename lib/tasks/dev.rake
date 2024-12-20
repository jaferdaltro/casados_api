namespace :dev do
  DEFAULT_PASSWORD = "password"

  desc "Setup the development environment"
  task setup: :environment do
    puts %x(docker compose down && docker compose up -d) if Rails.env.development?
    puts %x(rails db:drop db:create db:migrate db:seed) if Rails.env.development?
  end

  desc "Add default coordinator user"
  task add_coordinator: :environment do
    puts "Adding a coordinator"
    Faker::Config.locale = "pt-BR"
    User.create!(
      name: Faker::Name.name,
      phone: Faker::PhoneNumber.cell_phone,
      email: Faker::Internet.email,
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD,
      cpf: CPF.generate,
      gender: "male",
      role: "coordinator"
    ) if Rails.env.development?
    puts "Coordinator added"
  end

  desc "Add students"
  task add_students: :environment do
    puts "Adding 500 students"
    Faker::Config.locale = "pt-BR"
    500.times do
      husband = User.create!(
        name: Faker::Name.name,
        phone: Faker::PhoneNumber.cell_phone,
        email: Faker::Internet.email,
        password: DEFAULT_PASSWORD,
        password_confirmation: DEFAULT_PASSWORD,
        cpf: CPF.generate,
        gender: "male",
      ) if Rails.env.development?

      wife = User.create!(
        name: Faker::Name.female_first_name,
        phone: Faker::PhoneNumber.cell_phone,
        email: Faker::Internet.email,
        password: DEFAULT_PASSWORD,
        password_confirmation: DEFAULT_PASSWORD,
        cpf: CPF.generate,
        gender: "female",
      ) if Rails.env.development?

      address = Address.create!(
        street: Faker::Address.street_name,
        number: Faker::Address.building_number,
        neighborhood: Faker::Address.community,
        city: Faker::Address.city,
        state: Faker::Address.state_abbr,
        cep: Faker::Address.zip_code
      ) if Rails.env.development?

      Marriage.create!(
        husband_id: husband.id,
        wife_id: wife.id,
        address_id: address.id,
        is_member: [ true, false ].sample,
        registered_by: [ "Leo", "Jafer", "Carlos", "Fabício" ].sample,
        reason: Faker::Fantasy::Tolkien.poem,
        campus: [ "CN Fortleza", "CN Eusébio", "CN Maraponga" ].sample,
        days_availability: [ "monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday" ].sample(2)
      ) if Rails.env.development?
    end

    puts "#{User.count} Usuários criados\n #{Marriage.count} Casais criados"
  end
end
