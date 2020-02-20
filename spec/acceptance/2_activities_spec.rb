require 'byebug'
require_relative "acceptance_helper"

class ActivityLogSpec < Minitest::Spec 
  include ::Capybara::DSL
  include ::Capybara::Minitest::Assertions

  def self.test_order
    :alpha #run the tests in this file in order
  end

  # Sleeps are to make sure the page has loaded before we continue
  # Also so we can se what's happening

  before do
    visit '/'
    within("#login-form") do
      fill_in('username', with: "apple@frukt.se")
      fill_in('password', with: "123")
      click_button 'Logga in'
      sleep 1
    end
  end

  after do 
    Capybara.reset_sessions!
  end

  it 'check for activity log id' do
        _(page).must_have_css('#log-activity')
  end

  it 'write text in 4 textareas' do

    time = Time.now.to_s #to get a unique string

    @done = "Test fill: Lorem ipsum dolor sit amet: " << time
    @learned = "Test fill: Consectetur adipiscing elit: " << time
    @understood = "Test fill: Nam iaculis felis at lacus efficitur: " << time
    @more = "Test fill: A tempor urna lacinia: " << time

    within("#activity-log-form") do 
      sleep 1
      fill_in 'done', with: @done
      sleep 1
      fill_in 'learned', with: @learned
      sleep 1
      fill_in 'understood', with: @understood
      sleep 1
      fill_in 'more', with: @more
      sleep 1
      click_button 'Spara'
      sleep 1
    end

    _(page).must_have_content(@done)
    _(page).must_have_content(@learned)
    _(page).must_have_content(@understood)
    _(page).must_have_content(@more)

  end

end
