source 'https://rubygems.org'

ruby '2.5.7'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

# Server requirements
gem 'thin'

# Project requirements
gem 'rake'

# Component requirements
gem 'active_model_serializers', '~> 0.10.0'
gem 'activemodel', require: 'active_model'
gem 'json'
gem 'pg', '~> 0.18'
gem 'sequel'

# Padrino Stable Gem
gem 'padrino', '~> 0.14'

group :development, :test do
  gem 'capybara'
  gem 'cucumber'
  gem 'faraday'
  gem 'rack-test', require: 'rack/test'
  gem 'rspec'
  gem 'rspec_junit_formatter'
  gem 'rubocop', '~> 0.59.2', require: false
  gem 'rubocop-rspec', require: false
  gem 'simplecov'
end

group :development do
  gem 'byebug'
  gem 'guard'
  gem 'guard-rspec'
end
