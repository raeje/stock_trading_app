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

      # Authentication
      post 'signup' => 'authentication#signup'
      put 'login' => 'authentication#login'

      # Orders
      post 'orders/new' => 'orders#create'
    end
  end
end
