# frozen_string_literal: true

source "https://rubygems.org"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8.0.2"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use postgresql as the database for Active Record
gem "pg"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma"

# Bundle and transpile JavaScript [https://github.com/rails/jsbundling-rails]
gem "jsbundling-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Tailwind CSS for Rails
gem "tailwindcss-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Redis adapter to run Action Cable in production
gem "redis"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[windows jruby]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem "image_processing"

# Use slim-rails for HTML templating
gem "slim-rails"

# Use devise for authentication and session
gem "devise"

# FriendlyId is the "Swiss Army bulldozer" of slugging and permalink plugins for Active Record.
# It lets you create pretty URLs and work with human-friendly strings as if they were numeric ids
gem "friendly_id"

# Ruby library for the Stripe API
gem "stripe"

# Pagination
gem "pagy"

# Rails engine for cache-friendly, client-side local time
gem "local_time"

# The Cloudinary Ruby on Rails SDK allows you to quickly and easily integrate your application with Cloudinary.
# Effortlessly optimize, transform, upload and manage your cloud's assets.
gem "cloudinary"

# Validates active storage
gem "active_storage_validations"

gem "honeybadger"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[mri windows]

  # Configuration
  gem "dotenv-rails"

  # Testing Framework
  gem "rspec-rails"

  # A library for generating fake data such as names, addresses, and phone numbers
  gem "faker"

  # A fixtures replacement with a straightforward definition syntax, support for multiple build strategies [https://github.com/thoughtbot/factory_bot_rails]
  gem "factory_bot_rails"

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false

  gem "bundler-audit", require: false

  # Optimize queries [https://github.com/flyerhzm/bullet]
  gem "bullet"

  ## Code Formatting & Linting
  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop-rails-omakase", require: false
  # Code style checking for RSpec files [https://github.com/rubocop/rubocop-rspec]
  gem "rubocop-rspec", require: false
  # Code style checking for Rails-related RSpec files [https://github.com/rubocop/rubocop-rspec_rails]
  gem "rubocop-rspec_rails", require: false
  gem "rubocop-capybara", require: false
  gem "rubocop-factory_bot", require: false
  gem "rubocop-rails", require: false
  # Interact with the Ruby syntax tree [https://github.com/ruby-syntax-tree/syntax_tree]
  gem "syntax_tree", require: false
  # Provides a comprehensive suite of tools for Ruby programming: intellisense, diagnostics, inline documentation,
  # and type checking [https://github.com/castwide/solargraph]
  gem "solargraph", require: false
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"

  ## Code Formatting & Linting
  # Configurable tool for analyzing Slim templates [https://github.com/sds/slim-lint]
  gem "slim_lint", require: false
  # A normaliser/beautifier for HTML that also understands embedded Ruby. Ideal for tidying up Rails templates
  # [https://github.com/threedaymonk/htmlbeautifier]
  gem "htmlbeautifier", require: false

  # Git hooks manager [https://github.com/evilmartians/lefthook]
  gem "lefthook", require: false
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"

  gem "shoulda-matchers"

  # A code coverage analysis tool for Ruby [https://github.com/simplecov-ruby/simplecov]
  gem "simplecov", require: false
end
