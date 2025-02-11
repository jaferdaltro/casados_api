# t.decimal "lat", precision: 10, scale: 6
# t.decimal "lng", precision: 10, scale: 6

require "roo"
namespace :address do
  desc "Update address with lat lng"
  task :update, [ :filename ] => :environment do |t, args|
    xlsx = Roo::Spreadsheet.open("#{Rails.root}/lib/xlsx/relatorio.xlsx")
    sheet = xlsx.sheet(0) # Acessa a primeira aba

    count = 0
    row_number = 1
    sheet.each(city: "Cidade", cpf: "CPF do Marido", phone: "Telefone Marido", email_husband: "E-mail do Marido", email_wife: "E-mail da Esposa", shirt_husband: "Blusa marido", shirt_wife: "Blusa esposa", day: "Dia") do |row|
      next if row[:city] == "Cidade"
      row_number += 1

      cpf = cpf_normalize(row[:cpf])
      phone = phone_normalize(row[:phone])
      student = Marriage.by_cpf(cpf) || Marriage.by_phone(phone)
      student.husband.update_columns(email: row[:email_husband], shirt: row[:shirt_husband])
      wife_baby = row[:shirt_wife].match? /baby\s*look/i
      student.wife.update_columns(email: row[:email_wife], shirt: row[:shirt_wife], baby_look: wife_baby)
      student.update_columns(active: true, days_availability: [ set_day(row[:day]) ])

      count += 1
      puts "Atualizado: #{row[:cpf]}"
      if student.address.to_coordinates.nil?
        puts "Atulizado #{row[:cpf]} - Coordenadas não encontradas: #{student.address}"
      else
        puts "Atulizado #{row[:cpf]} - Coordenadas #{student.address.to_coordinates}"
      end
    rescue ActiveRecord::RecordInvalid => e
      puts "Erro na linha #{row_number}: #{e.message}"
      puts "Dados: #{row}"
    end
    puts "Total de casamentos atualizados: #{count}"
  end
end

def cpf_normalize(cpf)
  st_cpf = CPF.new(cpf)
  st_cpf.valid? ? st_cpf.stripped : nil
end

def phone_normalize(phone)
  "#{phone}".gsub(/^(\+?55\s?)/, "").gsub(/\D/, "")
end


def set_day(day)
  case day
  when "Segunda"
    "monday"
  when "Terça"
    "tuesday"
  when "Quarta"
    "wednesday"
  when "Quinta"
    "thursday"
  when "Sexta"
    "friday"
  when "Sabado"
    "saturday"
  else
    "Invalid day. Please enter a valid day of the week."
  end
end
