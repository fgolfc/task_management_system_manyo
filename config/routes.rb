Rails.application.routes.draw do
  namespace :admin do
    resources :users, only: [:index, :new, :create, :show, :edit, :update, :destroy] do
      member do
        patch 'toggle_admin'
      end
    end
  end
  
  resources :tasks do
    get 'search', on: :collection
  end
  
  root 'home#index'
  
  get 'login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy', as: :logout
  
  resources :users, only: [:index, :new, :edit, :update]
end