Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root 'pages#home'
  resources :products, only: [:index, :show]

  get 'about', to: 'pages#about', as: 'about'
  get 'contact', to: 'pages#contact', as: 'contact'

  # Cart routes
  post 'cart/add/:id', to: 'cart#add_to_cart', as: 'add_to_cart'
  get 'cart', to: 'cart#view_cart', as: 'cart'
  patch 'cart/update/:id', to: 'cart#update_cart', as: 'update_cart'
  delete 'cart/remove/:id', to: 'cart#remove_from_cart', as: 'remove_from_cart'

  # Optional: Increment/Decrement routes for better UX
  patch 'cart/increment/:id', to: 'cart#increment', as: 'increment_cart'
  patch 'cart/decrement/:id', to: 'cart#decrement', as: 'decrement_cart'

  # Checkout routes
  get 'checkout', to: 'checkout#new', as: 'checkout'
  post 'checkout', to: 'checkout#create'
  get 'orders/:id/confirmation', to: 'checkout#confirmation', as: 'order_confirmation'

  get "up" => "rails/health#show", as: :rails_health_check
end