require 'rails_helper'

feature 'The admin interface' do
  scenario 'is used to enqueue a POF Session Job' do
    ActiveJob::Base.queue_adapter = :test
    user = create(:user)
    create(:admin_user, email: "foo@example.com", password: "foobar")

    visit new_admin_user_session_path
    fill_in "Email", with: "foo@example.com"
    fill_in "Password", with: "foobar"
    click_button "Login"
    click_link "Users"
    within "#user_#{user.id}" do
      click_link "View"
    end

    click_link "Enqueue Pof Session"
    expect(PofSessionJob).to have_been_enqueued.with(user_id: user.id)
  end
end
