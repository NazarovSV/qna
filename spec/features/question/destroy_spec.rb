require 'rails_helper'

feature 'User can delete his question', %q{
  In order to delete non-actual question
  As an authenticated user
  I want to be able to delete my question
} do

  given(:question) { create(:question) }

  describe 'Authenticated user' do
    scenario 'can delete his question' do
      sign_in(question.user)

      visit questions_path

      click_on 'Delete question'

      expect(current_path).to eq(questions_path)
      expect(page).to_not have_content question.title
      expect(page).to have_content 'Your question has been successfully deleted'
    end

    scenario "cannot delete someone else's question" do
      sign_in(create(:user))

      visit questions_path

      expect(page).to_not have_link 'Delete question'
    end

  end

  scenario 'Unauthenticated cannot delete any question' do
    visit questions_path

    expect(page).to_not have_link 'Delete question'
  end
end