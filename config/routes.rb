Rails.application.routes.draw do
  root 'users#new'

  namespace :admin do
    resources :users do
      member do
        patch 'toggle_admin'
      end
    end
  end

  resources :tasks do
    get 'search', on: :collection
  end

  resources :users, only: [:index, :new, :create, :edit, :update], except: [:destroy]

  get 'users/admin_index', to: 'users#admin_index'

  get 'login', to: 'sessions#new', as: :new_session
  post 'login', to: 'sessions#create', as: :create_session
  delete 'logout', to: 'sessions#destroy', as: :logout
end