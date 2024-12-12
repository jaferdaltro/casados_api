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
namespace :import_leaders do
  desc "Import the leaders men data"
  task :leader_men, [ :filename ] => :environment do |t, args|
    log_dir = Rails.root.join("log", "imports")
    FileUtils.mkdir_p(log_dir)
    log_path = File.join(log_dir, "#{Time.now.strftime('%Y%m%d%H%M%S')}.log")

    imports = 0
    errors = 0
    File.open(log_path, "w") do |log|
      CSV.foreach("#{Rails.root}/lib/csv/liderancas.csv", headers: :first_row) do |csv|
        husband = User.new(
          name: csv["MARIDO"],
          phone: csv["WHATSAPP_MARIDO"],
          cpf: sanitize(csv["CPF_MARIDO"]),
          birth_at: csv["NASCIMENTO_MARIDO"],
          gender: :male,
          role: 2,
          password: "123456",
          password_confirmation: "123456"
        )
        wife = User.new(
          name: csv["ESPOSA"],
          phone: csv["WHATSAPP_ESPOSA"],
          cpf: sanitize(csv["CPF_ESPOSA"]),
          birth_at: csv["NASCIMENTO_ESPOSA"],
          gender: :female,
          role: 2,
          password: "123456",
          password_confirmation: "123456"
        )
        if husband.save && wife.save
          marriage = Marriage.new(husband_id: husband.id, wife_id: wife.id)
          if marriage.save
            imports += 1
            print "."
          else
            errors += 1
            log.puts "Erro ao importar: #{marriage.id} - #{ marriage.errors.full_messages}"
            log.puts "------------"
            print "F"
          end
        else
          errors += 1
          log.puts "Erro ao importar: #{husband.name} - #{ husband.errors.full_messages}"
          log.puts "Erro ao importar: #{wife.name} - #{ wife.errors.full_messages}"
          log.puts "------------"
          print "F"
        end
     end
    end
    puts "\n\nImportação concluída:"
    puts "Total importado: #{imports}"
    puts "Total de erros: #{errors}"
  end
  def sanitize(c)
    cpf = CPF.new(c)
    cpf.stripped if cpf.valid?
  end
 end
