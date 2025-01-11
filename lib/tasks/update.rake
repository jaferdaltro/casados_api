# t.string "name"
# t.string "phone", null: false
# t.string "cpf"
# t.string "email"
# t.date "birth_at"
# t.integer "role", default: 0
# t.string "gender"
# t.string "t_shirt_size"
# t.string "password_digest", null: false
require "csv"
require "cpf_cnpj"
namespace :update do
  desc "Update UUID"
  task :uuid, [ :filename ] => :environment do |t, args|
    count = 0
    Marriage.all.each do |marriage|
      marriage.update(uuid: SecureRandom.uuid)
      count += 1
    end
    puts "Total de casamentos atualizados: #{count}"
  end
end
