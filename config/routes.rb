# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  namespace :api do
    namespace :v1 do
      # Users
      get 'users' => 'users#index'
      patch 'users/update/:id' => 'users#update'
      post 'users/new' => 'users#create'
      get 'users/portfolio' => 'users#portfolio'
      get 'users/orders' => 'users#my_orders'
      get 'users/me' => 'users#me'

      # Authentication
      post 'signup' => 'authentication#signup'
      put 'login' => 'authentication#login'

      # Orders
      get 'orders' => 'orders#index'
      post 'orders/new' => 'orders#create'

      # Stocks
      get 'stocks/' => 'stocks#index'
      get 'stocks/:id' => 'stocks#show'
    end
  end
end
