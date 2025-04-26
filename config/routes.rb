Rails.application.routes.draw do
  # Toujours mettre devise en premier !
  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations",
    passwords: "users/passwords",
    confirmations: "users/confirmations"
  }

  root "home#index"

  resources :users do
    resources :reviews, only: [ :new, :create, :edit, :update, :destroy ]
  end

  # Route pour afficher toutes les reviews d'un utilisateur
  get "users/:user_id/reviews", to: "reviews#index", as: "custom_user_reviews"

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

  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
