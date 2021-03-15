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
    describe 'as question author' do
      background do
        sign_in user
        visit questions_path

        click_on 'Edit'
      end


      scenario 'edits his question' do

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

      scenario 'add new files for question' do
        within '.questions' do
          attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb","#{Rails.root}/spec/spec_helper.rb"]

          click_on 'Save'
        end

        visit question_path question

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end

      scenario 'edits his question with errors' do
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
    end


    scenario "tries to edit other's question" do
      sign_in create(:user)
      visit questions_path

      expect(page).to_not have_link 'Edit'
    end
  end
end