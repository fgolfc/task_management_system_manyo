Rails.application.routes.draw do
  root 'users#new'

  namespace :admin do
    resources :users do
      member do
        patch 'toggle_admin'
        get 'user/:id', to: 'users#show', as: :user_detail
      end
    end
  end

  resources :tasks do
    get 'search', on: :collection
  end

  resources :users, only: [:index, :new, :create, :edit, :update, :show], except: [:destroy]

  get 'users/admin_index', :to => redirect('/admin/users')

  get 'login', to: 'sessions#new', as: :new_session
  post 'login', to: 'sessions#create', as: :create_session
  delete 'logout', to: 'sessions#destroy', as: :logout
end