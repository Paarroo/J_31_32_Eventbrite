Rails.application.routes.draw do
  # Page d'accueil
  root 'events#home'

  # Authentification
  devise_for :users

  # Utilisateurs
  resources :users, only: [ :show, :edit, :update, :destroy ]

  # Événements avec inscriptions
  resources :events do
    resources :attendances, only: [ :create, :destroy ]
  end

  # Route pour voir les participants d'un événement
  get 'events/:id/participants', to: 'events#participants', as: 'event_participants'

  # Route pour les événements d'un utilisateur
  get 'my_events', to: 'events#my_events', as: 'my_events'
end
