#NOTE:
#
#When we click a submit button, unless we assert something about the content on
#the resulting page, capybara wont wait for the request to finish.
#
#So we can submit a form, then check the expected results before code has
#actually executed.
def force_capybara_to_wait_for_page_to_load
  expect(page).to have_content("")
end
