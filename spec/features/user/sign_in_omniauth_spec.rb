require 'rails_helper'

feature 'User can authorization from providers', '
  I want to be able to log in to the site
  as a user
  via social network' do
  describe 'new user' do
    describe 'github' do
      before do
        visit new_user_registration_path
      end

      scenario 'user can login with github account' do
        mock_auth_hash(provider: 'github', email: 'user@example.com')

        click_on 'Sign in with GitHub'

        expect(page).to have_content 'Successfully authenticated from Github account.'
      end

      scenario 'can handle authentication error' do
        OmniAuth.config.mock_auth[:github] = :invalid
        click_on 'Sign in with GitHub'

        expect(page).to have_content 'Could not authenticate you from GitHub'
      end

      describe 'vkontakte' do
        before do
          visit new_user_registration_path
        end

        scenario 'user can login with vk account' do
          clear_emails
          mock_auth_hash(provider: 'vkontakte')

          click_on 'Sign in with Vkontakte'
          fill_in 'Email', with: 'user1@example.com'

          click_on 'Send'

          open_email('user1@example.com')

          current_email.click_link('Confirm my account')

          click_on 'Sign in with Vkontakte'

          expect(page).to have_content 'Successfully authenticated from VK account.'
        end

        scenario 'user cant login with vk account without confirmation' do
          clear_emails
          mock_auth_hash(provider: 'vkontakte')

          click_on 'Sign in with Vkontakte'
          fill_in 'Email', with: 'user1@example.com'

          click_on 'Send'
          click_on 'Login'
          click_on 'Sign in with Vkontakte'

          expect(page).to have_content "Confirm your email user1@example.com!"
        end

        scenario 'can handle authentication error' do
          OmniAuth.config.mock_auth[:vkontakte] = :invalid
          click_on 'Sign in with Vkontakte'

          expect(page).to have_content 'Could not authenticate you from Vkontakte'
        end

        scenario 'error, if email has already been taken' do
          user = create(:user)

          clear_emails
          mock_auth_hash(provider: 'vkontakte')

          click_on 'Sign in with Vkontakte'
          fill_in 'Email', with: user.email

          click_on 'Send'

          expect(page).to have_content 'Email has already been taken'
        end
      end
    end
  end

  describe 'user exists', js: true do
    given!(:user) { create(:user) }

    before do
      visit new_user_session_path
    end

    describe 'github' do
      scenario 'user can login with github account' do
        mock_auth_hash(provider: 'github', email: user.email)

        click_on 'Sign in with GitHub'

        expect(page).to have_content 'Successfully authenticated from Github account.'
      end

      scenario 'can handle authentication error' do
        OmniAuth.config.mock_auth[:github] = :invalid
        click_on 'Sign in with GitHub'

        expect(page).to have_content 'Could not authenticate you from GitHub'
      end
    end
  end
end
