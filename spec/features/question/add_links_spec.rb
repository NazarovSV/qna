require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to able to add links
} do
  given(:user) { create(:user) }
  given(:url) { 'https://thoughtbot.com/blog/automatically-wait-for-ajax-with-capybara' }
  given(:another_url) { 'https://gist.github.com/Qtechknow/3581263' }

  scenario 'User adds links when asks question', js: true do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    click_on 'add link'

    within '.nested-fields' do
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: url
    end

    click_on 'add link'

    within all('.nested-fields').last do
      fill_in 'Link name', with: 'My gist2'
      fill_in 'Url', with: another_url
    end

    click_on 'Ask'

    expect(page).to have_link 'My gist', href: url
    expect(page).to have_link 'My gist2', href: another_url
  end
end