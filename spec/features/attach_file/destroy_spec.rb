# frozen_string_literal: true

require 'rails_helper'

feature 'User can delete files', '
  In order to delete non-actual files
  As an authenticated user
  I want to be able to delete my attached files
' do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, :with_attachment_file, user: user) }

  describe 'delete attached files from question' do
    describe 'as authenticate user', js: true do
      scenario 'delete files from my question' do
        sign_in user
        visit question_path(question)

        click_on 'remove file'

        expect(page).to_not have_link question.files.first.filename.to_s
      end

      scenario 'try to delete files from someone question' do
        sign_in create(:user)
        visit question_path(question)

        expect(page).to_not have_link 'remove file'
      end
    end

    scenario 'as unauthenticate user try to delete files from question' do
      visit question_path(question)

      expect(page).to_not have_link 'remove file'
    end
  end


end
