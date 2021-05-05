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
        within ".answer-new-comment" do
          fill_in 'body', with: 'text text text'
          click_on 'Post'
        end

        within ".answer-comments-#{answer.id}" do
          expect(page).to have_content 'text text text'
        end
      end

      scenario 'posts an invalid comment' do
        within ".answer-new-comment" do
          click_on 'Post'
        end

        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  describe 'Unauthenticated user', js: true  do
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
end
