require 'byebug'
require_relative "acceptance_helper"

class LoginLogoutSpec < Minitest::Spec 
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

  it 'user login and log out' do
    within("#login-form") do
      fill_in('username', with: "apple@frukt.se")
      fill_in('password', with: "123")
      click_button 'Logga in'
    end

    sleep 2

    _(page).must_have_css('#log-activity')

    find('a', text: 'Logga ut').click

    _(page).must_have_css('#login-form')
  end

end
