# frozen_string_literal: true

require 'rails_helper'

feature 'User can see question with answers', '
  To solve the problem,
  as an authenticated and non-authenticated user,
  I can look at the question with answers
' do
  given(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 5, question: question) }

  scenario 'Authenticated user sees a question with answers' do
    user = create(:user)
    sign_in(user)
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body

    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end

  scenario 'Unauthenticated user sees a question with answers' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body

    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end
