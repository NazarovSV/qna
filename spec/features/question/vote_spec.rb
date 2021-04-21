# frozen_string_literal: true

require 'rails_helper'

feature 'User can vote for a question', %q{
  In order to show that question is good
  As an authenticated user
  I'd like to be able to vote
} do

  given(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    scenario 'can vote for the question' do
      user = create(:user)
      sign_in(user)
      visit question_path(question)

      click_on '+'

      within("#question_rating_total_#{question.id}") do
        expect(page).to have_content '1'
      end
    end

    scenario "can't vote for his question" do
      sign_in(question.user)
      visit question_path(question)

      within(".question_rating") do
        expect(page).to_not have_content '+'
        expect(page).to_not have_content '-'
      end
    end

    scenario "can't vote for question twice" do
      user = create(:user)
      sign_in(user)
      visit question_path(question)

      click_on '+'
      click_on '+'

      within("#question_rating_total_#{question.id}") do
        expect(page).to have_content '0'
      end
    end

    scenario "can cancel and re-vote" do
      user = create(:user)
      create(:vote, :like, votable: question, user: user)

      sign_in(user)
      visit question_path(question)

      click_on '+'
      click_on '-'

      within("#question_rating_total_#{question.id}") do
        expect(page).to have_content '-1'
      end
    end
  end

  scenario 'Unauthenticated user cant vote for the question' do
    visit question_path(question)

    within(".question_rating") do
      expect(page).to_not have_link '+'
      expect(page).to_not have_link '-'
      expect(page).to have_content '0'
    end
  end

end
