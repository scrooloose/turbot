require 'rails_helper'

feature 'The interests + messages settings screens' do
  scenario 'User updates their interests and messages' do
    user = create(:user, email: "foo@bar.com", password: "foobar")

    biking = create(:interest, :biking)
    create(:interest, :running)
    create(:interest, :cooking)
    create(:template_message, interest: biking, user: user, content: "I suck at biking")

    login(user)

    click_link "Settings"

    check "Cooking"
    click_button "Save"

    expect(page).to have_content("I suck at biking")

    fill_in "Message for Cooking", with: "im pro at cooking"
    fill_in "Message for Biking", with: "im pro at biking too"
    click_button "Save"

    expect(user.reload.template_messages.map(&:content)).to match_array(
      ["im pro at cooking", "im pro at biking too"]
    )
  end
end
