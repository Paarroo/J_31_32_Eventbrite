Rails.application.routes.draw do
  root 'events#home'

  # Authentification utilisateurs (publique)
  devise_for :users

  # ================================
  # 🎯 ZONE D'ADMINISTRATION
  # ================================
  namespace :admin do
    root 'dashboard#index'

    # Authentification admin séparée
    get 'login', to: 'sessions#new', as: :login
    post 'login', to: 'sessions#create'
    delete 'logout', to: 'sessions#destroy', as: :logout

    # Gestion des utilisateurs
    resources :users do
      member do
        patch :toggle_admin
      end
    end

    # Gestion des événements
    resources :events

    # Validation des événements
    resources :event_submissions, only: [ :index, :show, :edit, :update ]
  end

  # Routes publiques...
  resources :users, only: [ :index, :show, :edit, :update ]
  resources :events do
    resources :payments, only: [ :new, :create ] do
      collection do
        get :success
        get :cancel
      end
    end
    resources :attendances, only: [ :create, :destroy ]
  end

  get 'my_events', to: 'events#my_events'
  get 'events/:id/participants', to: 'events#participants', as: 'event_participants'
end
