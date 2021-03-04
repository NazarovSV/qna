require 'rails_helper'

feature 'User can sign out', %q{
  to end the session,
  as an authenticated user,
  I would like to log out
} do

  scenario 'Registered user tries to sign out' do
    user = create(:user)
    sign_in(user)

    visit questions_path

    click_on 'Logout'

    expect(page).to have_content 'Signed out successfully.'
  end

  scenario 'Unregistered user tries to sign out' do
    visit questions_path

    expect(page).to_not have_content 'Logout'
  end
end
