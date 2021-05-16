require 'rails_helper'

RSpec.describe OauthCallbacksController, type: :controller do
  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe 'github' do
    let!(:oauth_data) { mock_auth_hash(provider: 'github', email: 'user@example.com') }
    it 'finds user from oauth data' do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
      expect(User).to receive(:find_for_oauth).with(oauth_data)
      get :github
    end

    context 'user exists' do
      let!(:user) { create(:user) }

      before do
        allow(User).to receive(:find_for_oauth).and_return(user)
        get :github
      end

      it 'login user if it exists' do
        expect(subject.current_user).to eq user
      end

      it 'redirect to root path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'user does not exist' do
      before do
        request.env['omniauth.auth'] = mock_auth_hash(provider: 'github', email: 'user@example.com')
      end

      it 'redirect to root path' do
        get :github
        expect(response).to redirect_to root_path
      end

      it 'create user' do
        expect { get :github }.to change(User, :count).by(1)
      end
    end
  end
end
