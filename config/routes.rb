Rails.application.routes.draw do
  #get 'posts/index'
  resources :posts

  resources :users, only: [:create]
  get 'users/new'
  get '/register', to: 'users#new'

  root 'posts#index'
end
