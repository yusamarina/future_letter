Rails.application.routes.draw do
  root 'users#new'

  resources :users, only: %i[create]
  resources :letters, only: %i[create new update edit index destroy] do
    member do
      get 'reserve'
    end
  end
  resources :send_letters, only: %i[create new index destroy]

  get 'letters/:token', to: 'letters#invite'
  get 'open', to: 'letters#open'
  get 'confirm', to: 'letters#confirm'
  get 'message', to: 'letters#message'

  get 'send_letters/:token', to: 'send_letters#show', as: 'read_letter'
  get 'login', to: 'send_letters#login'

  get 'privacy', to: 'home#privacy'
  get 'terms', to: 'home#terms'
  get 'description', to: 'home#description'
  get 'top', to: 'home#top'
  get 'mypage', to: 'home#mypage'
  get 'friend', to: 'home#friend'

  post 'callback', to: 'linebot#callback'
end
