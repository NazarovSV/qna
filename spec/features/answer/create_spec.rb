# frozen_string_literal: true

require 'rails_helper'

feature 'User can create answer for question', '
  To solve the problem
  as an authorized user,
  I would like to leave an answer on the question page
' do
  given(:question) { create(:question) }

  describe 'Authenticated user' do
    given(:user) { create(:user) }

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'answers the question' do
      fill_in 'Body', with: 'text text text'
      click_on 'Post Your Answer'

      expect(page).to have_content 'Your answer successfully created!'
      expect(page).to have_content 'text text text'
    end

    scenario 'answers the question with errors' do
      click_on 'Post Your Answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user answers the question' do
    visit question_path(question)
    expect(page).to_not have_content 'Post Your Answer'
  end
end
