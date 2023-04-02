Rails.application.routes.draw do
  root 'sessions#new'

  namespace :admin do
    resources :users do
      member do
        patch 'toggle_admin'
      end
      collection do
        get 'new', to: 'users#new', as: 'new_user'
      end
    end
  end
  get 'new_user', to: 'users#new', as: 'new_user'
  resources :users, only: [:index, :show, :edit, :update, :destroy] 

  resources :tasks do
    get 'search', on: :collection
  end

  get 'login', to: 'sessions#new', as: :new_session
  post '/login', to: 'sessions#create', as: :create_session
  delete 'logout', to: 'sessions#destroy', as: :logout
end