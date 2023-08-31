Rails.application.routes.draw do
  #get 'posts/index'
  resources :posts do
    resources :comments, only: [:create, :destroy]
  end

  resources :likes, only: [:destroy, :create]

  resources :sessions, only: [:create, :destroy]
  get 'sessions/new'
  get 'sing_in', to: 'sessions#new'
  delete 'sign_out', to: 'sessions#destroy'

  resources :users, only: [:create, :destroy]
  get 'users/new'
  get '/register', to: 'users#new'

  root 'posts#index'
end
