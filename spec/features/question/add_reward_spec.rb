require 'rails_helper'

feature 'User can add reward to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to able to add reward for best answer
} do
  given(:user) { create(:user) }

  scenario 'User adds reward when asks question', js: true do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'
    fill_in 'Reward name', with: 'reward'

    attach_file 'Image', "#{Rails.root}/spec/support/files/img.png"

    click_on 'Ask'

    expect(page).to have_link 'reward'
  end
end