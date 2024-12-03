  # This file should ensure the existence of records required to run the application in every environment (production,
  # development, test). The code here should be idempotent so that it can be executed at any point in every environment.
  # The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
  #
  # Example:
  #
  # ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
  #   MovieGenre.find_or_create_by!(name: genre_name)
  # end

  amanda = User.create!(name: 'Amanda', phone: '85999354538', gender: 'female', email: 'a@a', password: '123456', password_confirmation: '123456', role: 'coordinator')
  gustavo = User.create!(name: 'Gustavo', phone: '11999992399', gender: 'male', email: 'a@a', password: '123456', password_confirmation: '123456', role: 'coordinator')
  Marriage.create!(husband_id: gustavo.id, wife_id: amanda.id, is_member: true, campus: 'A', reason: 'A')

  almeida = User.create!(name: 'Almeida', phone: '12999999955', email: 'a@a', gender: 'male', password: '123456', password_confirmation: '123456', role: 'coordinator')
  porsina = User.create!(name: 'Porsina', phone: '11999999954', email: 'a@a', gender: 'female', password: '123456', password_confirmation: '123456', role: 'coordinator')
  Marriage.create!(husband_id: almeida.id, wife_id: porsina.id, is_member: true, campus: 'A', reason: 'A')

  pedro = User.create!(name: 'Pedro', phone: '11999926999', email: 'a@a', gender: 'male', password: '123456', password_confirmation: '123456', role: 'student')
  maria = User.create!(name: 'Maria', phone: '11999109999', email: 'a@a', gender: 'female', password: '123456', password_confirmation: '123456', role: 'student')
  Marriage.create!(husband_id: pedro.id, wife_id: maria.id, is_member: true, campus: 'A', reason: 'A')

  tib = User.create!(name: 'Tiburcio', phone: '11999432999', email: 'a@a', gender: 'male', password: '123456', password_confirmation: '123456', role: 'student')
  eme = User.create!(name: 'Emengarda', phone: '12999432999', email: 'a@a', gender: 'female', password: '123456', password_confirmation: '123456', role: 'student')
  Marriage.create!(husband_id: tib.id, wife_id: eme.id, is_member: true, campus: 'A', reason: 'A')
