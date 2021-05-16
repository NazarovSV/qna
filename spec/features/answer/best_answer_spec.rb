require 'rails_helper'

feature 'User can choose the best answer', '
  In order to show the correct answer,
  as the author of the question,
  I want to be able to choose the best answer
' do
  
  describe 'single session' do
    given!(:user) { create(:user) }
    given!(:question) { create(:question, user: user) }
    given!(:answer) { create(:answer, question: question, user: user) }
    given!(:link) { create(:link, linkable: answer) }
    given!(:gist_link) { create(:link, :gist, linkable: answer) }

    
    scenario 'User cannot choose the best answer if he is not the author of the question', js: true do
      sign_in create(:user)

      visit question_path(question)

      expect(page).to_not have_link 'Best Answer!'
    end

    describe 'Question author', js: true do
      background do
        sign_in user
      end

      scenario 'can choose the best answer' do
        visit question_path(question)

        click_on 'Best Answer!'

        sleep 1

        within '.best_answer' do
          expect(page).to have_content answer.body
          expect(page).to have_link link.name
          expect(page).to have_content 'Gist for test!'
          expect(page).to have_link 'remove link'
        end

        expect(page).to_not have_selector(class: 'answers')
      end

      scenario 'can choose another better answer' do
        best_answer = create(:answer, question: question)

        visit question_path(question)

        within "#answer_id_#{answer.id}" do
          click_on 'Best Answer!'
        end

        sleep 1

        within "#answer_id_#{best_answer.id}" do
          click_on 'Best Answer!'
        end

        within '.best_answer' do
          expect(page).to have_content best_answer.body
          expect(page).to_not have_content answer.body
        end

        within "#answer_id_#{answer.id}" do
          expect(page).to have_content answer.body
        end
      end
    end
  end
  
  describe 'Multiple session' do
    given!(:user) { create(:user) }
    given!(:question) { create(:question, user: user) }
    
    scenario 'immediately sees the added answer and can select it as the best answer', js: true do
      Capybara.using_session('another user') do
        sign_in(create(:user))
        visit question_path(question)
      end

      Capybara.using_session('question author') do
        sign_in(question.user)
        visit question_path(question)
      end

      Capybara.using_session('another user') do
        fill_in 'Body', with: 'text text text'

        click_on 'Post Your Answer'
      end

      Capybara.using_session('question author') do
        click_on 'Best Answer!'

        sleep 1

        within '.best_answer' do
          expect(page).to have_content 'text text text'
        end
      end
    end

  end
end
