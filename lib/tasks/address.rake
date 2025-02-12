# t.decimal "lat", precision: 10, scale: 6
# t.decimal "lng", precision: 10, scale: 6

require "roo"
namespace :address do
  desc "Create or update addresses from Excel file"
  task :sync, [ :filename ] => :environment do |t, args|
    xlsx = Roo::Spreadsheet.open("#{Rails.root}/lib/xlsx/#{args[:filename] || 'relatorio.xlsx'}")
    sheet = xlsx.sheet(0)

    count = { created: 0, updated: 0, errors: 0 }
    row_number = 1
    failed_records = []

    sheet.each(
      city: "Cidade",
      cpf: "CPF do Marido",
      phone: "Telefone Marido",
      email_husband: "E-mail do Marido",
      email_wife: "E-mail da Esposa",
      shirt_husband: "Blusa Marido",
      shirt_wife: "Blusa Esposa",
      street: "Endereco",
      day: "Dia"
    ) do |row|
      row_number += 1
      next if row[:city] == "Cidade"

      ActiveRecord::Base.transaction do
        cpf = cpf_normalize(row[:cpf])
        phone = phone_normalize(row[:phone])

        # Find or initialize marriage
        student = Marriage.find_or_initialize_by(
          husband: User.find_by(cpf: cpf) || User.find_by(phone: phone)
        )

        if student.new_record?
          create_new_marriage(student, row)
          count[:created] += 1
          puts "Created new marriage for CPF: #{cpf}"
        else
          update_existing_marriage(student, row)
          count[:updated] += 1
          puts "Updated marriage for CPF: #{cpf}"
        end

        # Update address
        address_data = parse_address(row[:street])
        student.address ||= Address.new
        student.address.update!(
          street: address_data[:street],
          number: address_data[:number],
          complement: address_data[:complement],
          city: row[:city],
          state: "Ceara"
        )

        log_coordinates(student, row)

        # After address update
        if student.address&.latitude.nil? || student.address&.longitude.nil?
          failed_records << student
          puts "Failed to get coordinates for: #{student.address&.location}"
        end
      end

    rescue StandardError => e
      count[:errors] += 1
      puts "Error on row #{row_number}: #{e.message}"
      puts "Data: #{row.inspect}"
    end

    save_failed_coordinates_to_json(failed_records)
    puts "Total records without coordinates: #{failed_records.size}"
    print_summary(count)
  end

  private

  def parse_address(address_string)
    match = address_string.match(/^(?<rua>[^,]+),\s*(?<numero>\d+),\s*(?<complemento>.+)$/)

    if match
      {
        street: match[:rua],
        number: match[:numero],
        complement: match[:complemento]
      }
    else
      { street: address_string }
    end
  end

  def create_new_marriage(student, row)
    student.build_husband(
      email: row[:email_husband],
      t_shirt_size: row[:shirt_husband],
      cpf: cpf_normalize(row[:cpf]),
      phone: phone_normalize(row[:phone])
    )

    student.build_wife(
      email: row[:email_wife],
      t_shirt_size: row[:shirt_wife],
      baby_look: row[:shirt_wife].match?(/baby\s*look/i)
    )

    student.days_availability = [ set_day(row[:day]) ]
    student.active = true
    student.save!
  end

  def update_existing_marriage(student, row)
    student.husband.update!(
      email: row[:email_husband],
      t_shirt_size: row[:shirt_husband]
    )

    student.wife.update!(
      email: row[:email_wife],
      t_shirt_size: row[:shirt_wife],
      baby_look: row[:shirt_wife].match?(/baby\s*look/i)
    )

    student.update!(
      active: true,
      days_availability: [ set_day(row[:day]) ]
    )
  end

  def log_coordinates(student, row)
    identification = row[:cpf].present? ? "CPF: #{row[:cpf]}" : "Phone: #{row[:phone]}"

    if student.address.nil? || student.address.latitude.nil?
      puts "Geolocation not found for #{identification}"
    else
      puts "#{identification} - Coordinates: #{student.address.to_coordinates}"
    end
    puts "-----------------------------------"
  end

  def print_summary(count)
    puts "\nSummary:"
    puts "Created: #{count[:created]}"
    puts "Updated: #{count[:updated]}"
    puts "Errors: #{count[:errors]}"
    puts "Total processed: #{count.values.sum}"
  end

  def save_failed_coordinates_to_json(failed_records)
    return if failed_records.empty?

    timestamp = Time.current.strftime("%Y%m%d_%H%M%S")
    filepath = Rails.root.join("tmp", "failed_coordinates_#{timestamp}.json")

    failed_data = failed_records.map do |record|
      {
        id: record.id,
        street: record.address&.street,
        number: record.address&.number,
        city: record.address&.city,
        state: record.address&.state,
        location: record.address&.location,
        husband_name: record.husband&.name,
        wife_name: record.wife&.name,
        created_at: record.created_at
      }
    end

    File.write(filepath, JSON.pretty_generate(failed_data))
    puts "Failed coordinates saved to: #{filepath}"
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
