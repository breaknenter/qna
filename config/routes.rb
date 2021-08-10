Rails.application.routes.draw do
  root 'questions#index'

  resources :questions do
    resources :answers, only: %i[create]
  end
end
