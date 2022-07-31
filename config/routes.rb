Rails.application.routes.draw do
  # root 'home#top'
  root 'users#new'

  resources :users, only: %i[create]
  resources :letters, only: %i[create new update edit index destroy reserve] do
    member do
      get 'reserve'
    end
  end
  resources :send_letters

  # get 'login', to: 'users#new'
  get 'open', to: 'letters#open'
  get 'message', to: 'letters#message'
  get 'letters/:token', to: 'letters#invite'
  get 'privacy', to: 'home#privacy'
  get 'terms', to: 'home#terms'
  get 'description', to: 'home#description'
  get 'top', to: 'home#top'
  get 'mypage', to: 'home#mypage'
  post 'callback', to: 'linebot#callback'
end
