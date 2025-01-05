namespace :fix_dinner do
  desc "Fix the dinner participation"
  task dinner: :environment do
    count = 0
    students = Marriage.joins(:husband).where("husband.role" => 0, created_at: "2024-12-17 16:41:15.944"..Time.now.midnight - 7.days)
    puts "Number of marriages:
     #{students.count} marriages..."
    students.each do |marriage|
      marriage.update(dinner_participation: true)
      count += 1
    end
    puts "Dinner participation fixed!"
    puts "Number of marriages fixed: #{count}"
  end
end
