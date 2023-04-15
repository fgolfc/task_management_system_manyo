Rails.application.routes.draw do
  get 'users/new', to: 'users#new', as: :new_user
  
  namespace :admin do
    resources :users, only: [:index]
  end

  namespace :admin do
    resources :users do
      member do
        patch 'toggle_admin'
        get 'user/:id', to: 'users#show', as: :user_detail
        get 'users' 
        get 'edit', to: 'users#edit', as: :edit_admin_user
      end
    end
  end

  root 'tasks#index'

  resources :tasks do
    get 'search', on: :collection
  end

  resources :users, only: [:new, :create, :edit, :update, :show], as: :user do
    member do
      get 'edit', to: 'users#edit', as: :edit_user
    end
  end
  get '/users', to: 'users#index', as: :users

  get 'login', to: 'sessions#new', as: :new_session
  post 'login', to: 'sessions#create', as: :create_session
  delete 'logout', to: 'sessions#destroy', as: :logout
end