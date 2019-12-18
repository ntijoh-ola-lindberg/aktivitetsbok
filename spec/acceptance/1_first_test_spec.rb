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

  it 'write text in 4 textareas' do
    @time = Time.now #to get a unique string
    within("#activity-log-form") do 
      fill_in('log-done', with: "Test: Lorem ipsum dolor sit amet: #{@time}" )
      fill_in('log-learned', with: "Test: Consectetur adipiscing elit: #{@time}" )
      fill_in('log-understood', with: "Test: Nam iaculis felis at lacus efficitur: #{@time}" )
      fill_in('log-more', with: "Test: A tempor urna lacinia: #{@time}" )
      click_button 'Spara'
    end

    within("#activity") do
      _(page).must_have_content("Test: Lorem ipsum dolor sit amet: #{@time}")
      _(page).must_have_content("Test: Consectetur adipiscing elit: #{@time}")
      _(page).must_have_content("Test: Nam iaculis felis at lacus efficitur: #{@time}")
      _(page).must_have_content("Test: A tempor urna lacinia: #{@time}")
    end

  end

end
