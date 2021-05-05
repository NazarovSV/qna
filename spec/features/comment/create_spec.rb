require 'rails_helper'
feature 'User can create comment', "
  To discuss a question or answer,
  As an authenticated user
  I'd like to be able to comment on questions and answers
" do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, user: user, question: question) }

  describe 'Authenticated user', js: true do
    describe 'comments on the question' do
      background do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'posts a valid comment' do
        within '.question-new-comment' do
          fill_in 'body', with: 'text text text'
          click_on 'Post'
        end

        within ".question-comments-#{question.id}" do
          expect(page).to have_content 'text text text'
        end
      end

      scenario 'posts an invalid comment' do
        within '.question-new-comment' do
          click_on 'Post'
        end

        expect(page).to have_content "Body can't be blank"
      end
    end

    describe 'comments on the answer' do
      background do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'posts a valid comment' do
        within '.answer-new-comment' do
          fill_in 'body', with: 'text text text'
          click_on 'Post'
        end

        within ".answer-comments-#{answer.id}" do
          expect(page).to have_content 'text text text'
        end
      end

      scenario 'posts an invalid comment' do
        within '.answer-new-comment' do
          click_on 'Post'
        end

        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  describe 'Unauthenticated user', js: true do
    background do
      visit question_path(question)
    end

    scenario 'cant comment question' do
      within '.question' do
        expect(page).to_not have_content 'Post'
      end
    end

    scenario 'cant comment answer' do
      within '.answers' do
        expect(page).to_not have_content 'Post'
      end
    end
  end

  describe 'Multiple sessions' do
    given!(:second_user) { create(:user) }

    scenario 'All users authenticated. When a user comments question,
      all users who have this question open see the comment immediately', js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('second user') do
        sign_in(second_user)
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.question-new-comment' do
          fill_in 'body', with: 'text text text'
          click_on 'Post'
        end
      end

      Capybara.using_session('second user') do
        within ".question-comments-#{question.id}" do
          expect(page).to have_content 'text text text'
        end
      end
    end

    scenario 'All users authenticated. When a user comments answer,
    all users who have this question open see the comment immediately', js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('second user') do
        sign_in(second_user)
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.answer-new-comment' do
          fill_in 'body', with: 'text text text'
          click_on 'Post'
        end
      end

      Capybara.using_session('second user') do
        within ".answer-comments-#{answer.id}" do
          expect(page).to have_content 'text text text'
        end
      end
    end

    scenario 'As a guest user, I will immediately see a comment on the question page when another user
     comments question.', js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.question-new-comment' do
          fill_in 'body', with: 'text text text'
          click_on 'Post'
        end
      end

      Capybara.using_session('guest') do
        within ".question-comments-#{question.id}" do
          expect(page).to have_content 'text text text'
        end
      end
    end
  end
end
