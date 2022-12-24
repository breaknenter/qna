require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, -> (user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper

  root 'questions#index'

  devise_for :users,
             path_names: { 
               sign_up:  :register,
               sign_in:  :login,
               sign_out: :logout
             },
             controllers: { omniauth_callbacks: 'oauth_callbacks' }

  concern :voteable do
    member do
      post :vote_up
      post :vote_down
    end
  end

  concern :commentable do
    post :create_comment, on: :member
  end

  resources :questions, concerns: %i[voteable commentable] do
    resources :answers, concerns: %i[voteable commentable], shallow: true, only: %i[create update destroy] do
      post :best, on: :member
    end

    resources :subscriptions, shallow: true, only: %i[create destroy]
  end

  resources :files, only: :destroy
  resources :links, only: :destroy

  resources :rewards, only: :index

  resource :email, only: %i[new create], controller: :email

  namespace :api do
    namespace :v1 do
      resources :profiles, only: :index do
        get :me, on: :collection
      end

      resources :questions, only: %i[index create show update destroy] do
        get :answers, on: :member

        resources :answers, shallow: true, only: %i[create update show destroy]
      end
    end
  end

  get :search, to: 'search#show'
end
