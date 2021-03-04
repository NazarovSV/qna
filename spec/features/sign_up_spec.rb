require 'rails_helper'

feature 'User can sign up', %q{
  To ask questions,
  as an unregistered user,
  I want to be able to register on the site
} do

  scenario 'Unautharized user tries to sign up' do
    visit questions_path

    click_on 'Registration'

    fill_in 'Email', with: 'test@test.ru'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'

    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'Unautharized user tries to sign up with invalid data' do
    visit questions_path

    click_on 'Registration'

    click_on 'Sign up'

    expect(page).to have_content "prohibited this user from being saved"
    expect(page).to have_content "Email can't be blank"
    expect(page).to have_content "Password can't be blank"
  end

  scenario 'Registered user does not see the registration' do
    user = create(:user)
    sign_in(user)
    visit questions_path

    expect(page).to_not have_content 'Registration'
  end
end
