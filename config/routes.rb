Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root 'pages#home'
  resources :products, only: [:index, :show]

  get 'about', to: 'pages#about', as: 'about'
  get 'contact', to: 'pages#contact', as: 'contact'

  post 'cart/add/:id', to: 'cart#add_to_cart', as: 'add_to_cart'
  get 'cart', to: 'cart#view_cart', as: 'cart'

  get "up" => "rails/health#show", as: :rails_health_check
end