require_relative "../spec_helper"
require_relative "../../app.rb"

require 'capybara/minitest'
require 'capybara/minitest/spec'
require 'rack/test'

Capybara.app = App
Capybara.default_driver = :selenium_chrome
Capybara.server = :webrick