# frozen_string_literal: true

require 'rails_helper'

feature 'User can delete files', '
  In order to delete non-actual files
  As an authenticated user
  I want to be able to delete my attached files
' do

  given!(:user) { create(:user) }

  describe 'delete link from question' do
    given!(:question) { create(:question, user: user) }
    given!(:link) { create(:link, linkable: question) }

    describe 'as authenticate user', js: true do
      scenario 'delete link from my question' do
        sign_in user
        visit question_path(question)

        click_on 'remove link'

        expect(page).to_not have_link link.name
      end

      scenario 'try to delete link from someone question' do
        sign_in create(:user)
        visit question_path(question)

        expect(page).to_not have_link 'remove link'
      end
    end

    scenario 'as unauthenticate user try to delete link from question' do
      visit question_path(question)

      expect(page).to_not have_link 'remove link'
    end
  end

  describe 'delete link from answer' do
    given!(:question) { create(:question, user: user) }
    given!(:answer) { create(:answer, question: question, user: user ) }
    given!(:link) { create(:link, linkable: answer) }

    describe 'as authenticate user', js: true do
      scenario 'delete link from my answer' do
        sign_in user
        visit question_path(question)

        click_on 'remove link'

        expect(page).to_not have_link link.name
      end

      scenario 'try to delete link from someone answer' do
        sign_in create(:user)
        visit question_path(question)

        expect(page).to_not have_link 'remove link'
      end
    end

    scenario 'as unauthenticate user try to delete link from answer' do
      visit question_path(question)

      expect(page).to_not have_link 'remove link'
    end
  end


end
