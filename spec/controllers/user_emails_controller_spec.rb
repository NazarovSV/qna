# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserEmailsController, type: :controller do

  describe 'GET #new' do
    it 'renders new view' do
      get :new
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      before do
        session[:uid] = '123'
        session[:provider] = 'provider'
      end

      it 'saves a new user in the database' do
        expect do
          post :create, params: { email: 'test@example.com' }
        end.to change(User, :count).by(1)
      end

      it 'saves a new user authorized in the database' do
        expect do
          post :create, params: { email: 'test@example.com' }
        end.to change(Authorization, :count).by(1)
      end

      it 'redirects to root path' do
        post :create, params: { email: 'test@example.com' }
        expect(response).to redirect_to root_path
      end
    end

    context 'with invalid attributes' do
      describe 'without email' do
        before do
          session[:uid] = '123'
          session[:provider] = 'provider'
        end

        it 'does not save the user' do
          expect do
            post :create, params: { email: nil }
          end.to change(User, :count).by(0)
        end

        it 'does not save the user authorization' do
          expect do
            post :create, params: { email: nil }
          end.to change(Authorization, :count).by(0)
        end

        it 'render new' do
          post :create, params: { email: nil }
          expect(response).to render_template :new
        end
      end

      describe 'without uid & provider' do

        it 'does not save the user' do
          expect do
            post :create, params: { email: 'test@example.com' }
          end.to change(User, :count).by(0)
        end

        it 'does not save the user authorization' do
          expect do
            post :create, params: { email: 'test@example.com' }
          end.to change(Authorization, :count).by(0)
        end

        it 'render new' do
          post :create, params: { email: 'test@example.com' }
          expect(response).to render_template :new
        end
      end
    end
  end

end
