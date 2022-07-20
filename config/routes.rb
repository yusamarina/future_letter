Rails.application.routes.draw do
  root 'users#new'

  resources :users, only: %i[new create]
  resources :letters
  resources :letter_sending_dates

  get 'message', to: 'letters#message'
  post 'callback', to: 'linebot#callback'
end
