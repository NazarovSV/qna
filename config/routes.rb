# frozen_string_literal: true

Rails.application.routes.draw do
  use_doorkeeper
  get 'rewards/index'
  get 'links/destroy'
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }
  root to: 'questions#index'

  concern :votable do
    member do
      patch :like
      patch :dislike
    end
  end

  concern :commentable do
   post :comment, on: :member
  end

  resources :questions, concerns: %i[votable commentable], shallow: true do
    resources :answers, concerns: %i[votable commentable], shallow: true, only: %i[create destroy update] do
      patch :best_answer, on: :member
    end
  end

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [] do
        get :me, on: :collection
        get :other, on: :collection
      end
      resources :questions, only: [:index]
    end
  end

  resource :user_emails, only: %i[new create]

  resources :attachment_files, only: %i[destroy]
  resources :links, only: %i[destroy]
  resources :rewards, only: %i[index]
end
