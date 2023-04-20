Rails.application.routes.draw do
  resources :labels, path: 'labels' do
    collection do
      get 'new', as: 'new_label'
      get ':id/edit', as: 'edit_label', action: :edit
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

  get '/signup', to: 'users#new', as: :new_user_form
  post '/signup', to: 'users#create', as: :create_user

  namespace :admin do
    resources :users, only: [:index, :new, :create, :show, :edit, :update, :destroy] do
      member do
        patch 'toggle_admin'
      end
    end
  end

  post 'login', to: 'sessions#create', as: :create_session
  get 'login', to: 'sessions#new', as: :new_session
  delete 'logout', to: 'sessions#destroy', as: :logout
  get '/logout', to: 'sessions#destroy', as: :logout_get
end