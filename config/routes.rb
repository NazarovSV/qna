# frozen_string_literal: true

Rails.application.routes.draw do
  get 'links/destroy'
  devise_for :users
  root to: 'questions#index'

  resources :questions, shallow: true do
    resources :answers, shallow: true, only: %i[create destroy update] do
      patch :best_answer, on: :member
    end
  end

  resources :attachment_files, only: %i[destroy]
  resources :links, only: %i[destroy]
end
