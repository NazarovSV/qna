require 'rails_helper'

feature 'User can authorization from providers', '
  I want to be able to log in to the site
  as a user
  via social network' do
  describe 'new user', js: true do
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
    end
  end

  describe 'user exists', js: true do
    given!(:user) { create(:user, email: 'user@example.com') }

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
