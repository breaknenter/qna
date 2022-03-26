Rails.application.routes.draw do
  root 'questions#index'

  devise_for :users,
             path_names: { 
               sign_up:  :register,
               sign_in:  :login,
               sign_out: :logout
             }

  concern :voteable do
    member do
      post :vote_up
      post :vote_down
    end
  end

  resources :questions, concerns: :voteable do
    resources :answers, concerns: :voteable, shallow: true, only: %i[create update destroy] do
      post :best, on: :member
    end
  end

  resources :files, only: :destroy
  resources :links, only: :destroy

  resources :rewards, only: :index
end
