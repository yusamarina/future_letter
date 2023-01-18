Rails.application.routes.draw do
  root 'users#new'

  resources :users, only: %i[create]
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

  get 'top', to: 'home#top'
  get 'privacy', to: 'home#privacy'
  get 'terms', to: 'home#terms'
  get 'description', to: 'home#description'
  get 'mypage', to: 'home#mypage'
  get 'friend', to: 'home#friend'

  post 'callback', to: 'linebot#callback'

  namespace :admin do
    root 'dashboards#top'
    get 'login', to: 'user_sessions#new'
    post 'login', to: 'user_sessions#create'
    delete 'logout', to: 'user_sessions#destroy'
    resources :users, only: %i[index show destroy]
    resources :send_letters, only: %i[index show destroy]
  end

  namespace :demo do
    root 'home#top'
    get 'privacy', to: 'home#privacy'
    get 'terms', to: 'home#terms'
    get 'description', to: 'home#description'
    get 'mypage', to: 'home#mypage'
    get 'trial_letter', to: 'letters#trial'
    get 'draft_letter', to: 'letters#draft'
    get 'received_letter', to: 'letters#received'
    get 'mailed_letter', to: 'letters#mailed'
    get 'show_received_letter', to: 'letters#show_received'
    get 'show_mailed_letter', to: 'letters#show_mailed'
    get 'trial_anniversary', to: 'anniversaries#trial'
    get 'anniversaries', to: 'anniversaries#index'
    get 'anniversary', to: 'anniversaries#show'
  end
end
