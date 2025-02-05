# t.string "name"
# t.string "phone", null: false
# t.string "cpf"
# t.string "email"
# t.date "birth_at"
# t.integer "role", default: 0
# t.string "gender"
# t.string "t_shirt_size"
# t.string "password_digest", null: false
require "roo"
namespace :sended do
  desc "Update sended message"
  task :update, [ :filename ] => :environment do |t, args|
    xlsx = Roo::Spreadsheet.open("#{Rails.root}/lib/xlsx/mensaged.xlsx")
    sheet = xlsx.sheet(0) # Acessa a primeira aba

    count = 0
    sheet.each(nome: "nome", numero: "numero", email: "email") do |row|
      next if row[:numero] == "numero"

      phone = row[:numero]
      marriage = Marriage.by_phone(phone)
      marriage.update(messaged: true) if marriage.present?
      count += 1
    end

    puts "Total de casamentos atualizados: #{count}"
  end
end
