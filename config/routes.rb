Rails.application.routes.draw do
  root 'home#top'

  resources :users, only: %i[create new]
  resources :letters, only: %i[create new update edit index destroy] do
    member do
      get 'reserve'
    end
  end
  resources :send_letters, only: %i[create new index]
  resources :anniversaries

  get 'letters/:token', to: 'letters#invite'
  get 'open', to: 'letters#open'
  get 'confirm', to: 'letters#confirm'
  get 'message', to: 'letters#message'

  get 'send_letters/:token', to: 'send_letters#show', as: 'read_letter'
  get 'login', to: 'send_letters#login'
  get 'received', to: 'send_letters#received'

  get 'write', to: 'anniversaries#write'

  get 'privacy', to: 'home#privacy'
  get 'terms', to: 'home#terms'
  get 'description', to: 'home#description'
  get 'mypage', to: 'home#mypage'
  get 'friend', to: 'home#friend'

  post 'callback', to: 'linebot#callback'
end
