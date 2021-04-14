# frozen_string_literal: true

require 'rails_helper'

feature 'User can see the list of all his rewards for answer', "
  In order to see the list of the rewards
  As an authenticated user
  I would like to be able to see the list of my rewards
" do

  given!(:user) { create(:user) }
  given!(:answer_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:reward) { create(:reward, question: question, recipient: answer_user) }

  scenario 'Authenticated user can see the list of his rewards' do
    sign_in(answer_user)

    visit questions_path

    click_on 'Rewards'

    expect(page).to have_content question.title
    expect(page).to have_content reward.name
    expect(page).to have_css("img[src*='#{reward.image.filename}']")
  end

  scenario 'Unauthenticated user cant see the list of his rewards' do
    expect(page).to_not have_link 'Rewards'
  end
end
