Rails.application.routes.draw do
  root to: "static_pages#show", id: 'home'


  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :signups, only: [:new, :create]
  get 'register', to: redirect('/signups/new'), as: :register

  resources :template_message_setups, only: [:new, :create]
  resources :dashboards, only: :index
  resources :static_pages, only: [:show]
  resources :user_sessions
  get 'login' => 'user_sessions#new', :as => :login
  post 'logout' => 'user_sessions#destroy', :as => :logout
end
