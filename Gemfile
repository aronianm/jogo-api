source "https://rubygems.org"

ruby "3.2.2"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.1.3"
gem 'mysql2'

# Use sqlite3 as the database for Active Record
gem "sqlite3", "~> 1.4"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"


gem 'rack-cors'

gem 'devise'
gem 'devise-jwt'
gem 'jsonapi-serializer'

gem 'phonelib'

#deployments
# gem "capistrano"
# gem "capistrano-rails"
# gem "capistrano-bundler"
# gem "capistrano3-puma"
# gem 'capistrano-rvm'
# gem 'capistrano-puma'

# gem 'ed25519'
# gem 'bcrypt_pbkdf'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ]
end

group :development do
  gem 'pry'
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

