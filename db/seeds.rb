  # This file should ensure the existence of records required to run the application in every environment (production,
  # development, test). The code here should be idempotent so that it can be executed at any point in every environment.
  # The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
  #
  # Example:
  #
  # ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
  #   MovieGenre.find_or_create_by!(name: genre_name)
  # end

  %i[coordinator leader co_leader student].each do |role|
    amanda = User.create!(name: 'Amanda', phone: '85999354538', gender: 'female', email: 'a@a', password: '123456', password_confirmation: '123456', role: role)
    gustavo = User.create!(name: 'Gustavo', phone: '11999992399', gender: 'male', email: 'a@a', password: '123456', password_confirmation: '123456', role: amanda.role)
    Marriage.create!(husband_id: gustavo.id, wife_id: amanda.id, is_member: true, campus: 'A', registred_by: 'Amanda', reason: 'A')

    almeida = User.create!(name: 'Almeida', phone: '12999999955', email: 'a@a', gender: 'male', password: '123456', password_confirmation: '123456', role: role)
    porsina = User.create!(name: 'Porsina', phone: '11999999954', email: 'a@a', gender: 'female', password: '123456', password_confirmation: '123456', role: almeida.role)
    Marriage.create!(husband_id: almeida.id, wife_id: porsina.id, is_member: true, campus: 'A', registred_by: 'Amanda', reason: 'A')

    pedro = User.create!(name: 'Pedro', phone: '11999926999', email: 'a@a', gender: 'male', password: '123456', password_confirmation: '123456', role: role)
    maria = User.create!(name: 'Maria', phone: '11999109999', email: 'a@a', gender: 'female', password: '123456', password_confirmation: '123456', role: pedro.role)
    Marriage.create!(husband_id: pedro.id, wife_id: maria.id, is_member: true, campus: 'A', registred_by: 'Amanda', reason: 'A')

    tib = User.create!(name: 'Tiburcio', phone: '11999432999', email: 'a@a', gender: 'male', password: '123456', password_confirmation: '123456', role: role)
    eme = User.create!(name: 'Emengarda', phone: '12999432999', email: 'a@a', gender: 'female', password: '123456', password_confirmation: '123456', role: tib.role)
    Marriage.create!(husband_id: tib.id, wife_id: eme.id, is_member: true, campus: 'A', registred_by: 'Amanda', reason: 'A')
  end
