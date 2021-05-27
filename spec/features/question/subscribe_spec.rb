require 'rails_helper'

feature 'User can subscribe to the question', %q{
  For information on new replies
  As an authenticated user
  I want to be notified by email
} do
  given!(:question) { create(:question) }
  describe 'Authenticated user' do
    describe 'not subscribed yet', js: true do
      before do
        sign_in(create(:user))
        visit question_path(question)
      end

      scenario 'have link to subscribe' do
        within '.question' do
          expect(page).to have_selector('a', class: 'subscribe')
        end
      end

      scenario 'have not link to unsubscribe' do
        within '.question' do
          expect(page).to_not  have_selector('a', class: 'unsubscribe')
        end
      end

      scenario 'cant subscribe twice', js: true do
        within '.question' do
          click_on 'subscribe'

          sleep 2
          expect(page).to_not have_selector('a', class: 'subscribe')
          expect(page).to have_selector('a', class: 'unsubscribe')
        end
      end
    end

    describe 'already subscribed' do
      given!(:subscriber) { create(:user) }
      given!(:subscription) { create(:subscription, user: subscriber, question: question )}

      before do
        sign_in(subscriber)
        visit question_path(question)
      end

      scenario 'have link to unsubscribe' do
        within '.question' do
          expect(page).to have_selector('a', class: 'unsubscribe')
        end
      end

      scenario 'have not link to subscribe' do
        within '.question' do
          expect(page).to_not  have_selector('a', class: 'subscribe')
        end
      end

      scenario 'cant unsubscribe twice', js: true do
        within '.question' do
          click_on 'unsubscribe'

          sleep 2
          expect(page).to_not have_selector('a', class: 'unsubscribe')
          expect(page).to have_selector('a', class: 'subscribe')
        end
      end
    end
  end

  describe 'Unauthenticated user' do

    before do
      visit question_path(question)
    end

    scenario 'user cant subscribe to a question' do
      within '.question' do
        expect(page).to_not have_link 'subscribe'
      end
    end

    scenario 'user cant unsubscribe to a question' do
      within '.question' do
        expect(page).to_not have_link 'unsubscribe'
      end
    end
  end
end