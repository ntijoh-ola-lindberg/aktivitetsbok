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
    within("#login-form") do
      fill_in('username', with: "apple@frukt.se")
      fill_in('password', with: "123")
      click_button 'Logga in'
    end
  end

  after do 
    Capybara.reset_sessions!
  end

  it 'check for activity log id' do
        _(page).must_have_css('#log-activity')
  end

  it 'write text in 4 textareas' do
    @time = Time.now #to get a unique string
    within("#activity-log-form") do 
      fill_in('log-done', with: "Test fill: Lorem ipsum dolor sit amet: #{@time}" )
      fill_in('log-learned', with: "Test fill: Consectetur adipiscing elit: #{@time}" )
      fill_in('log-understood', with: "Test fill: Nam iaculis felis at lacus efficitur: #{@time}" )
      fill_in('log-more', with: "Test fill: A tempor urna lacinia: #{@time}" )
      click_button 'Spara'
    end

    sleep 2

    within("#activity") do
      _(page).must_have_content("Test fill: Lorem ipsum dolor sit amet: #{@time}")
      _(page).must_have_content("Test fill: Consectetur adipiscing elit: #{@time}")
      _(page).must_have_content("Test fill : Nam iaculis felis at lacus efficitur: #{@time}")
      _(page).must_have_content("Test fill: A tempor urna lacinia: #{@time}")
    end

  end

  it 'update one activity' do
    @time = Time.now #to get a unique string

    first('a.edit-activity').click

    sleep 2

    within("#update_activity-log-form") do 
      fill_in('update_log-done', with: "Test update: Lorem ipsum dolor sit amet: #{@time}" )
      fill_in('update_log-learned', with: "Test update: Consectetur adipiscing elit: #{@time}" )
      fill_in('update_log-understood', with: "Test update: Nam iaculis felis at lacus efficitur: #{@time}" )
      fill_in('update_log-more', with: "Test update: A tempor urna lacinia: #{@time}" )
      click_button 'Uppdatera'
    end

    sleep 2

    within("#activity") do
      _(page).must_have_content("Test update: Lorem ipsum dolor sit amet: #{@time}")
      _(page).must_have_content("Test update: Consectetur adipiscing elit: #{@time}")
      _(page).must_have_content("Test update: Nam iaculis felis at lacus efficitur: #{@time}")
      _(page).must_have_content("Test update: A tempor urna lacinia: #{@time}")
    end

  end

end
