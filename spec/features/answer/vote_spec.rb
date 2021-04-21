# frozen_string_literal: true

require 'rails_helper'

feature 'User can vote for an answer', %q{
  In order to show that answer is good
  As an authenticated user
  I'd like to be able to vote
} do

  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  describe 'Authenticated user', js: true do
    scenario 'can vote for the answer' do
      user = create(:user)
      sign_in(user)
      visit question_path(question)

      within(".answer_rating_#{answer.id}") do
        click_on '+'
      end

      within("#answer_rating_total_#{answer.id}") do
        expect(page).to have_content '1'
      end
    end

    scenario "can't vote for his answer" do
      sign_in(answer.user)
      visit question_path(question)

      within(".answer_rating_#{answer.id}") do
        expect(page).to_not have_content '+'
        expect(page).to_not have_content '-'
      end
    end

    scenario "can't vote for answer twice" do
      user = create(:user)
      sign_in(user)
      visit question_path(question)

      within(".answer_rating_#{answer.id}") do
        click_on '+'
        click_on '+'
      end

      within("#answer_rating_total_#{answer.id}") do
        expect(page).to have_content '0'
      end
    end

    scenario "can cancel and re-vote" do
      user = create(:user)
      create(:vote, :like, votable: question, user: user)

      sign_in(user)
      visit question_path(question)

      within(".answer_rating_#{answer.id}") do
        click_on '+'
        click_on '-'
      end

      within("#answer_rating_total_#{answer.id}") do
        expect(page).to have_content '-1'
      end
    end
  end

  scenario 'Unauthenticated user cant vote for the answer' do
    visit question_path(question)

    within(".answer_rating_#{answer.id}") do
      expect(page).to_not have_link '+'
      expect(page).to_not have_link '-'
      expect(page).to have_content '0'
    end
  end

end
