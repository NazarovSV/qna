require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user ) }

  scenario 'Unauthenticated can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js:true do
    describe 'as answer author' do
      background do
        sign_in user
        visit question_path(question)
      end


      scenario 'edits his answer' do
        click_on 'Edit'

        within '.answers' do
          fill_in 'Your answer', with: 'edited answer'
          click_on 'Save'

          expect(page).to_not have_content answer.body
          expect(page).to have_content 'edited answer'
          expect(page).to_not have_selector 'textarea'
        end
      end

      scenario 'edits his answer with errors' do
        click_on 'Edit'

        within '.answers' do
          fill_in 'Your answer', with: ''
          click_on 'Save'

          expect(page).to have_selector 'textarea'
          expect(page).to have_content "Body can't be blank"
        end
      end

      scenario 'add new files for answer' do
        click_on 'Edit'

        within '.answers' do
          attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb","#{Rails.root}/spec/spec_helper.rb"]

          click_on 'Save'

          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end
      end

      scenario 'add new files for best answer' do
        click_on 'Best Answer!'
        click_on 'Edit'

        within '.best_answer' do
          attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb","#{Rails.root}/spec/spec_helper.rb"]

          click_on 'Save'

          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end
      end

    end

    scenario "tries to edit other's answer" do
      sign_in create(:user)

      visit question_path(question)
      expect(page).to_not have_link 'Edit'
    end
  end
end