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
  end

  desc "Add students"
  task add_students: :environment do
    puts "Adding 10 students"
    Faker::Config.locale = "pt-BR"
    10.times do
      User.create!(
        name: Faker::Name.name,
        phone: Faker::PhoneNumber.cell_phone,
        email: Faker::Internet.email,
        password: DEFAULT_PASSWORD,
        password_confirmation: DEFAULT_PASSWORD,
        cpf: CPF.generate,
        gender: %w[male female].sample,
      ) if Rails.env.development?
    end
  end
end
