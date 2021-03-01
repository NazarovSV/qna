Rails.application.routes.draw do
  resources :questions, shallow: true do
    resources :answers, only: %i[create new show]
  end
end
