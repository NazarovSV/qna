Rails.application.routes.draw do
  resources :questions, shallow: true do
    resources :answers, only: :show
  end
end
