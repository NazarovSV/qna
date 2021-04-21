# frozen_string_literal: true

Rails.application.routes.draw do
  get 'rewards/index'
  get 'links/destroy'
  devise_for :users
  root to: 'questions#index'

  concern :votable do
    member do
      patch :like
      patch :dislike
    end
  end

  resources :questions, concerns: :votable, shallow: true do
    resources :answers, concerns: :votable, shallow: true, only: %i[create destroy update] do
      patch :best_answer, on: :member
    end
  end

  resources :attachment_files, only: %i[destroy]
  resources :links, only: %i[destroy]
  resources :rewards, only: %i[index]
end
