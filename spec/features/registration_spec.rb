require 'rails_helper'

feature 'Registration' do
  scenario 'A user registers and goes through the template message wizard' do
    create(:interest, :running)
    create(:interest, :biking)
    create(:interest, :cooking)


    visit "/register"
    fill_in "Email", with: "new-user@bar.com"
    fill_in "Password", with: "foobar"
    fill_in "Pof username", with: "foo"
    fill_in "Pof password", with: "foo"
    fill_in "Name", with: "foo"
    click_button "Sign Up"

    check "Running"
    check "Biking"
    click_button "Step 2: Write your messages"

    fill_in "Message for Running", with: "Running is awesome!"
    fill_in "Message for Biking", with: "Biking is rad!"
    click_button "Save Messages"

    force_capybara_to_wait_for_page_to_load

    user = User.last
    expect(user.email).to eq("new-user@bar.com")
    expect(user.template_messages.map(&:content)).to match_array(["Running is awesome!", "Biking is rad!"])
  end
end
