namespace :fix_days_availability do
  desc "Fix the days availability"
  task days: :environment do
    previous_days = {
      "monday" => "sunday",
      "tuesday" => "monday",
      "wednesday" => "tuesday",
      "thursday" => "wednesday",
      "friday" => "thursday",
      "saturday" => "friday",
      "sunday" => "saturday"
    }
    puts "Fixing days availability..."
    Marriage.all.each do |marriage|
      days = marriage.days_availability.map { |day| previous_days[day] }

      marriage.update(days_availability: days)
    end
    puts "Days availability fixed!"
  end
end
