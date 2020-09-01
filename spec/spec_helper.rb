RACK_ENV = 'test'.freeze unless defined?(RACK_ENV)

require File.expand_path(File.dirname(__FILE__) + '/../config/boot')
Dir[File.expand_path(File.dirname(__FILE__) + '/../src/helpers/**/*.rb')].each(&method(:require))

require 'simplecov'

SimpleCov.start do
  root(File.join(File.dirname(__FILE__), '..'))
  coverage_dir 'reports/coverage'
  add_filter '/spec/'
  add_filter '/features/'
  add_filter '/admin/'
  add_filter '/db/'
  add_filter '/config/'
  add_group 'Models', 'src/models'
  add_group 'Controllers', 'src/controllers'
  add_group 'Helpers', 'src/helpers'
end

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
end

def app
  HealthApi::App.tap { |app| }
  HealthApi::App.set :protect_from_csrf, false
end
