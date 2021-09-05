Rails.application.routes.draw do
  get 'files/destroy'
  root 'questions#index'

  devise_for :users,
             path_names: { 
               sign_up:  :register,
               sign_in:  :login,
               sign_out: :logout
             }

  resources :questions do
    resources :answers, shallow: true, only: %i[create update destroy] do
      post :best, on: :member
    end
  end

  resources :files, only: :destroy
end
