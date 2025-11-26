Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root 'pages#home'
  resources :products, only: [:index, :show]

  get "up" => "rails/health#show", as: :rails_health_check
end