require 'rails_helper'

feature 'User can see a list of all questions', %q{
  In order to if the question I'm interested in has been asked
  as an authenticated and non-authenticated user,
  I want to see a list of all questions
} do

  scenario 'Authenticated user sees a list of all questions' do
    user = create(:user)
    questions = create_list(:question, 5)

    sign_in(user)

    visit questions_path

    questions.each do | question |
      expect(page).to have_content question.title
    end
  end

  scenario 'Unauthenticated user sees a list of all questions' do
    questions = create_list(:question, 5)

    visit questions_path

    questions.each do | question |
      expect(page).to have_content question.title
    end
  end
end
