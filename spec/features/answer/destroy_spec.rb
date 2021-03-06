# frozen_string_literal: true

require 'rails_helper'

feature 'User can delete his answer', '
  In order to delete non-actual answer
  As an authenticated user
  I want to be able to delete my answer
' do
  given(:user) { create(:user) }
  given(:answer) { create(:answer, user: user) }

  describe 'Authenticated user', js: true do
    scenario 'can delete his answer' do
      sign_in(answer.user)

      visit question_path(answer.question)

      click_on 'Delete'

      expect(current_path).to eq(question_path(answer.question))
      expect(page).to_not have_content answer.body
      expect(page).to have_content 'Your answer has been successfully deleted'
    end

    scenario "cannot delete someone else's answer" do
      sign_in(create(:user))

      visit question_path(answer.question)

      expect(page).to_not have_link 'Delete'
    end
  end

  scenario 'Unauthenticated cannot delete any answer', js: true do
    visit question_path(answer.question)

    expect(page).to_not have_link 'Delete'
  end
end
