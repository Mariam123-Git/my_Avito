Rails.application.routes.draw do
# Ajouter ces lignes dans votre fichier routes.rb existant
resources :users do
  resources :reviews, only: [ :new, :create, :edit, :update, :destroy ]
end
# Route pour afficher toutes les reviews d'un utilisateur
get "users/:user_id/reviews", to: "reviews#index", as: "custom_user_reviews"

  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations",
    passwords: "users/passwords",
    confirmations: "users/confirmations"
  }
  root "home#index"

  resources :listings do
    member do
      delete :delete_image
    end
    collection do
      get :my_listings
    end
  end

  resources :categories, only: [ :index, :show ]
  resources :cities, only: [ :index, :show ]
  resources :users, only: [ :show ]
  resources :messages, only: [ :index, :create, :show ]

  namespace :admin do
    root to: "dashboard#index"
    resources :categories
    resources :listings
    resources :users
    resources :regions
    resources :cities
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
  # root "home#index"
end
