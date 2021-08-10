Rails.application.routes.draw do
  root 'questions#index'

  devise_for :users,
             path_names: { 
               sign_up:  :register,
               sign_in:  :login,
               sign_out: :logout
             }

  resources :questions do
    resources :answers, only: %i[create]
  end
end
