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
    sheet.each(
      city: "Cidade",
      cpf: "CPF do Marido",
      endphone: "Telefone Marido",
      email_husband: "E-mail do Marido",
      endemail_wife: "E-mail da Esposa",
      shirt_husband: "Blusa Marido",
      shirt_wife: "Blusa Esposa",
      street: "Endereco",
      day: "Dia"
    ) do |row|
      next if row[:city] == "Cidade"
      row_number += 1

      cpf = cpf_normalize(row[:cpf])
      phone = phone_normalize(row[:phone])
      student = Marriage.by_cpf(cpf).last || Marriage.by_phone(phone).last
      puts "ESUDANTE NÃO ENCONTRADO CPF: #{cpf}" if student.nil?
      puts " -----------------------------------"
      next if student.nil?
      student.husband.update_columns(email: row[:email_husband], t_shirt_size: row[:shirt_husband])
      wife_baby = row[:shirt_wife].match? /baby\s*look/i
      student.wife.update_columns(email: row[:email_wife], t_shirt_size: row[:shirt_wife], baby_look: wife_baby)
      match = row[:street].match(/^(?<rua>[^,]+),\s*(?<numero>\d+),\s*(?<complemento>.+)$/)
      if match
        student.address.update_columns(street: match[:rua], number: match[:numero], complement: match[:complemento], city: row[:city])
      else
        student.address.update_columns(street: row[:street], city: row[:city]) if match
      end
      student.update_columns(active: true, days_availability: [ set_day(row[:day]) ])

      count += 1
      indentification = row[:cpf].present? ? "cpf: #{row[:cpf]}" : "phone: #{row[:phone]}"
      if student.address.latitude.nil?
        puts "Atulizado #{indentification} - Coordenadas não encontradas #{student.address.street}"
      else
        puts "Atulizado #{indentification} - Coordenadas #{student.address.to_coordinates}"
      end
      puts "-----------------------------------"
    rescue ActiveRecord::RecordNotFound
      puts "Erro na linha #{row_number}: Casamento não encontrado"
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

def street_normalize(street)
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
