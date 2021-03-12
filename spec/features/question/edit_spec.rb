require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of question
  I'd like to be able to edit my question
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Unauthenticated can not edit question' do
    visit questions_path

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: true do
    scenario 'edits his question' do
      sign_in user
      visit questions_path

      click_on 'Edit'

      within '.questions' do
        fill_in 'Title', with: 'New Title'
        fill_in 'Body', with: 'New Body'
        click_on 'Save'

        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
        expect(page).to have_content 'New Title'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his question with errors' do
      sign_in user
      visit questions_path

      click_on 'Edit'

      within '.questions' do
        fill_in 'Title', with: ''
        fill_in 'Body', with: ''
        click_on 'Save'

        expect(page).to have_content question.title
        expect(page).to have_content question.body
        expect(page).to have_selector 'input'
        expect(page).to have_selector 'textarea'
        expect(page).to have_content "Title can't be blank"
        expect(page).to have_content "Body can't be blank"
      end
    end
    scenario "tries to edit other's question" do
      sign_in create(:user)
      visit questions_path

      expect(page).to_not have_link 'Edit'
    end
  end
end