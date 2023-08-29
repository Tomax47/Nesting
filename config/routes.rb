Rails.application.routes.draw do
  #get 'posts/index'
  resources :posts, only: [:create, :destroy, :show, :update, :edit] do
    resources :comments, only: [:destroy, :create]
    get '/delete', to: 'comments#destroy'
  end

  get '/delete_post', to: 'posts#destroy'

  resources :likes, only: [:destroy, :create]

  resources :sessions, only: [:create, :destroy]
  get 'sessions/new'
  get 'sing_in', to: 'sessions#new'
  get 'sign_out', to: 'sessions#destroy'

  resources :users, only: [:create, :destroy]
  get 'users/new'
  get '/register', to: 'users#new'

  root 'posts#index'
end
