require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an answer's author
  I'd like to able to add links
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:url) { 'https://thoughtbot.com/blog/automatically-wait-for-ajax-with-capybara' }
  given(:another_url) { 'https://www.rambler.ru/' }
  given(:gist) { 'https://gist.github.com/NazarovSV/3f4c2beeeb901a8db1dab9419b2b37aa' }

  scenario 'User adds multiple links when give an answer', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Body', with: 'text text text'

    click_on 'add link'

    fill_in 'Link name', with: 'My url'
    fill_in 'Url', with: url

    click_on 'add link'

    within all('.nested-fields').last do
      fill_in 'Link name', with: 'Another url'
      fill_in 'Url', with: another_url
    end

    click_on 'Post Your Answer'

    within '.answers' do
      expect(page).to have_link 'My url', href: url
      expect(page).to have_link 'Another url', href: another_url
    end
  end

  scenario 'User adds not valid URL link when give an answer', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Body', with: 'text text text'

    click_on 'add link'

    fill_in 'Link name', with: 'My url'
    fill_in 'Url', with: '1111'

    click_on 'Post Your Answer'

    within '.answer-errors' do
      expect(page).to have_content "Links url is not a valid URL"
    end
  end

  scenario 'User adds a link to the gist and sees the gist', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Body', with: 'text text text'

    click_on 'add link'

    fill_in 'Link name', with: 'My url'
    fill_in 'Url', with: gist

    click_on 'Post Your Answer'

    expect(page).to have_content "Gist for test!"
  end
end