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
    puts "Number of marriages:
     #{Marriage.count} marriages..."
    Marriage.all.each do |marriage|
      next if marriage.days_availability&.blank? || marriage.days_availability&.compact.blank?
      days = marriage.days_availability.map { |day| previous_days[day] }
      marriage.update(days_availability: days)
    end
    puts "Days availability fixed!"
    puts "Number of marriages fixed: #{count}"
  end
end
