#require_relative '../environment'
require 'capybara/dsl'

Capybara.app = proc { |env| App.new.call(env) }

Capybara.configure do |config|
    config.default_driver = :selenium_chrome #comment for headless tests
    config.server = :webrick                 #comment for headless tests 
end

RSpec.configure do |config|
  config.include Capybara::DSL
  config.before { File.write("members.txt", "Anja\nMaren\n") }
end

