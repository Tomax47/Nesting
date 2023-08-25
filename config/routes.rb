Rails.application.routes.draw do
  #get 'posts/index'
  resources :posts

  root 'posts#index'
end
