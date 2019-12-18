require 'byebug'
require_relative "acceptance_helper"

class ActivityLogSpec < Minitest::Spec 
  include ::Capybara::DSL
  include ::Capybara::Minitest::Assertions

  def self.test_order
    :alpha #run the tests in this file in order
  end

  before do
    visit '/'
  end

  after do 
    Capybara.reset_sessions!
  end

  it 'check for activity log id' do
    sleep 1 #so we can see
    _(page).must_have_css('#log-activity')
  end

end
