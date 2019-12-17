require_relative 'spec_helper'

describe App do
  
  it 'shows 24 unopened doors on first run' do
    visit '/'
    sleep 1 #so we can see
    expect(page).to have_selector('.door.unopened', count: 24)
  end

  it 'shows the first image when clicking the first opened' do
    visit '/'
    click_link("1")
    sleep 1 #so we can see
    expect(page).to have_selector("img[src='/img/1.jpg']")
  end

  it 'shows 23 unopened doors after the first door has been opened' do
    visit '/'
    sleep 1 #so we can see
    expect(page).to have_selector('.door.unopened', count: 23)
  end


  #let(:links) { within('#members') { page.all('a').map(&:text) } }


  # it "listing members" do
  #   # go to the members list
  #   visit "/"

  #   # check the list of links
  #   expect(links).to eq ['Anja', 'Edit', 'Remove', 'Maren', 'Edit', 'Remove']
  # end

  # it "showing member details" do
  #   # go to the members list
  #   visit "/members"

  #   # click on the link
  #   click_on "Maren"

  #   # check the h1 tag
  #   expect(page).to have_css 'h1', text: 'Member: Maren'

  #   # check the name
  #   expect(page).to have_content 'Name: Maren'
  # end

  # it "creating a new member" do
  #   # go to the members list
  #   visit "/members"

  #   # click on the link
  #   click_on "New Member"

  #   # fill in the form
  #   fill_in "Name", :with => "Monsta"

  #   # submit the form
  #   click_on "Save"

  #   # check the current path
  #   expect(page).to have_current_path "/members/Monsta"

  #   # check the message
  #   expect(page).to have_content 'Successfully saved the new member: Monsta.'

  #   # check the h1 tag
  #   expect(page).to have_css 'h1', text: 'Member: Monsta'
  # end

  # it "updating a member" do
  #   # go to the members list
  #   visit "/members"

  #   # click on the link for Anja
  #   click_on "Edit", match: :first

  #   # fill in the form
  #   fill_in "Name", :with => "Tyranja"

  #   # submit the form
  #   click_on "Save"

  #   # check the current path
  #   expect(page).to have_current_path "/members/Tyranja"

  #   # check the message
  #   expect(page).to have_content 'Successfully updated the member: Tyranja.'

  #   # check the h1 tag
  #   expect(page).to have_css 'h1', text: 'Member: Tyranja'
  # end

  # it "removing a member" do
  #   # go to the members list
  #   visit "/members"

  #   # click on the link for Anja
  #   click_on "Remove", match: :first

  #   # check the message
  #   expect(page).to have_content /Are you sure .*?/

  #   # click the button
  #   click_on "Yes"

  #   # check the current path
  #   expect(page).to have_current_path "/members"

  #   # check the message
  #   expect(page).to have_content 'Successfully removed the member: Anja.'

  #   # check the list
  #   expect(page).to have_selector('li', count: 1)
  # end
end
