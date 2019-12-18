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

  it 'input text to textareas' do
    sleep 1
    @time = Time.now
    within("#activity-log-form") do 
      fill_in('log-done', with: "Jag har gjort kl #{@time}" )
      click_button 'Spara'
    end

    _(page).must_have_content("Jag har gjort kl #{@time}")

  end

end
