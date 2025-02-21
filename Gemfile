source "https://rubygems.org"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.2.2"
# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"
# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem "bcrypt", "~> 3.1.7"

gem "cpf_cnpj", "~> 1.0", ">= 1.0.1"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin Ajax possible
gem "rack-cors"

gem "dockerfile-rails", ">= 1.6", group: :development

gem "redis", "~> 5.3"

gem "roo"

gem "jwt", "~> 1.5", ">= 1.5.4"

gem "kaminari", "~> 1.2", ">= 1.2.2"

gem "sidekiq", "~> 7.3", ">= 7.3.7"
# gem "sidekiq-status", "~> 3.0", ">= 3.0.3"
#
gem "geocoder", "~> 1.3", ">= 1.3.7"

group :development, :test do
  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem

  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

  # Use dotenv-rails for environment variables
  gem "dotenv-rails", "~> 2.1", ">= 2.1.1"

  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop-rails-omakase", require: false

  gem "ultrahook", "~> 0.1.4"

  gem "factory_bot_rails", "~> 6.4", ">= 6.4.4"

  gem "shoulda-matchers", "~> 6.4"

  gem "rspec-rails", "~> 7.1"

  gem "faker", "~> 3.4", ">= 3.4.2"
end
