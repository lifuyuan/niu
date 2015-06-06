# coding: utf-8
if ENV['USE_OFFICIAL_GEM_SOURCE']
  source 'https://rubygems.org'
else
  source 'https://ruby.taobao.org'
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.8'
# Use sqlite3 as the database for Active Record
#gem 'sqlite3'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'execjs'
gem 'therubyracer'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring',        group: :development

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

# Mongoid 辅助插件
gem 'mongoid', '~> 4.0.0'
gem 'bson'
gem 'bson_ext'
gem 'mongoid_rails_migrations', '1.0.0'

# 自动化测试
group :development, :test do
  gem 'rspec-rails', '~> 3.1'
  gem 'factory_girl_rails', '~> 4.5.0'
  gem 'faker', '~> 1.4.3'
  gem 'capybara', '~> 2.4.4'
  gem 'database_cleaner', '~> 1.3.0'
  gem 'launchy', '~> 2.4.3'
  gem 'selenium-webdriver', '~> 2.44.0'
end

# 用户登录
gem 'devise', '~> 3.4.1'