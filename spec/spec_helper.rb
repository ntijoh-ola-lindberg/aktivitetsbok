# encoding: UTF-8
require 'bundler'

Bundler.setup
Bundler.require

require 'minitest/autorun'
require 'minitest/spec'
require 'minitest/reporters'

MiniTest::Reporters.use!(MiniTest::Reporters::SpecReporter.new)


class MiniTest::Spec
  include Rack::Test::Methods
end