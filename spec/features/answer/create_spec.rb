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

    scenario 'answers the question', js: true do
      fill_in 'Body', with: 'text text text'
      click_on 'Post Your Answer'

      expect(page).to have_content 'Your answer successfully created!'
      expect(page).to have_content 'text text text'
    end

    scenario 'answers the question with errors', js: true do
      click_on 'Post Your Answer'

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'answers the question with attached file', js: true do
      fill_in 'Body', with: 'text text text'

      attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

      click_on 'Post Your Answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario 'Unauthenticated user answers the question' do
    visit question_path(question)
    expect(page).to_not have_content 'Post Your Answer'
  end

  describe 'Multiple sessions' do
    given!(:user) { create(:user) }
    given!(:second_user) { create(:user) }

    scenario 'All users authenticated. When a user adds an answer to a question,
      all users who have this question open see the answer immediately', js: true do

      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('second user') do
        sign_in(second_user)
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'Body', with: 'text text text'
        attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

        click_on 'Post Your Answer'
      end

      Capybara.using_session('second user') do
        expect(page).to have_content 'text text text'
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'As a guest user, I will immediately see the answer on the question page when another user
     adds an answer to the question.', js: true do

      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'Body', with: 'text text text'
        attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

        click_on 'Post Your Answer'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'text text text'
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end
  end
end
