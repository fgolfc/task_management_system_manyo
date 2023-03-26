Rails.application.routes.draw do
  root 'tasks#index'
  resources :tasks do
    get 'search', on: :collection
  end
end
