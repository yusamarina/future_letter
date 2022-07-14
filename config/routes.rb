Rails.application.routes.draw do
  root 'letters#index'
  resources :users, only: [:create]
  resources :letters
end
