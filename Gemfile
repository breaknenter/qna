source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.4'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 6.1.4'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'
# Use Puma as the app server
gem 'puma', '~> 5.0'
# Slim
gem 'slim-rails'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 5.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false

# Devise
gem 'devise'

# Cloudinary
gem 'cloudinary'

# Cocoon
gem 'cocoon'

# Gon
gem 'gon'

# OAuth
gem 'omniauth'

# OAuth for Github
gem 'omniauth-github'

# OAuth for VK
gem 'omniauth-vkontakte'

# OmniAuth - Rails CSRF Protection
gem 'omniauth-rails_csrf_protection'

# CanCanCan authorization
gem 'cancancan'

#  Doorkeeper is an OAuth 2 provider for Ruby on Rails / Grape
gem 'doorkeeper'

# ActiveModel::Serializer implementation and Rails hooks
gem 'active_model_serializers', '~> 0.10'

# Optimized JSON
gem 'oj'

# Sidekiq - simple, efficient background processing for Ruby
gem 'sidekiq'

gem 'sinatra', require: false
gem 'whenever', require: false

# Sphinx
gem 'thinking-sphinx'
gem 'mysql2', '~> 0.5'

# Minimal embedded V8
gem 'mini_racer'

gem 'unicorn'

gem 'redis-rails'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # RSpec
  gem 'rspec-rails', '~> 5.0.0'
  gem 'rails-controller-testing'
  # Factory Girl
  gem 'factory_bot_rails'
  # Test your ActionMailer and Mailer messages with Capybara
  gem 'capybara-email'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 4.1.0'
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem 'rack-mini-profiler', '~> 2.0'
  gem 'listen', '~> 3.3'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  # Preview mail in the browser instead of sending
  gem 'letter_opener'
  # Capistrano gems
  gem 'capistrano',           require: false
  gem 'capistrano-bundler',   require: false
  gem 'capistrano-rbenv',     require: false
  gem 'capistrano-rails',     require: false
  gem 'capistrano-passenger', require: false
  gem 'capistrano-sidekiq',   require: false
  gem 'capistrano3-unicorn',  require: false
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 3.26'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
  # Shoulda Matchers
  gem 'shoulda-matchers', '~> 5.0'
  # Launchy: save_and_open_page
  gem 'launchy'
  # Strategies for cleaning databases
  gem 'database_cleaner-active_record'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
