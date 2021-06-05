# frozen_string_literal: true
require 'sidekiq/web'

Rails.application.routes.draw do
  get 'searches/index'
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

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

  resources :searches, only: :index

  resources :questions, concerns: %i[votable commentable], shallow: true do
    resources :answers, concerns: %i[votable commentable], shallow: true, only: %i[create destroy update] do
      patch :best_answer, on: :member
    end
    resources :subscriptions, only: %i[create destroy]
  end

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [] do
        get :me, on: :collection
        get :other, on: :collection
      end
      resources :questions, only: %i[index show create update destroy], shallow: true do
        resources :answers, only: %i[index show create update destroy], shallow: true
      end
    end
  end

  resource :user_emails, only: %i[new create]

  resources :attachment_files, only: %i[destroy]
  resources :links, only: %i[destroy]
  resources :rewards, only: %i[index]
end
