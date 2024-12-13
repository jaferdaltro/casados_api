namespace :fix_days_availability do
  desc "Fix the days availability"
  task days: :environment do
    count = 0
    previous_days = {
      "monday" => "sunday",
      "tuesday" => "monday",
      "wednesday" => "tuesday",
      "thursday" => "wednesday",
      "friday" => "thursday",
      "saturday" => "friday",
      "sunday" => "saturday"
    }
    puts "Number of marriages: #{Marriage.count} marriages..."
    Marriage.all.each do |marriage|
      next if marriage.days_availability.empty? || marriage.days_availability.nil? || marriage.days_availability.compact.empty?
      days = marriage.days_availability.map { |day| previous_days[day] }
      if marriage.update(days_availability: days)
        puts "Updating days availability for marriage #{marriage.days_availability}"
        count += 1
      end
    end
    puts "Days availability fixed!"
    puts "Number of marriages fixed: #{count}"
  end
end
