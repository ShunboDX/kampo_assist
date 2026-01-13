Rails.application.routes.draw do
  get "user_sessions/new"
  get "users/new"
  # ====== Health Check ======
  get "up" => "rails/health#show", as: :rails_health_check

  # ====== Home ======
  get "home/index"
  root "home#index"

  # ====== Static Pages (Legal) ======
  get "terms",   to: "static_pages#terms"
  get "privacy", to: "static_pages#privacy"
  get "/how_to",  to: "static_pages#how_to",  as: :how_to

  # ====== Search Flow ======
  resource :search, only: [] do
    get :step1
    get :step2
    get :results
  end

  # ====== Kampos ======
  resources :kampos, only: [ :show ] do
    # ====== Favorite ======
    resource :favorite, only: [ :create, :destroy ]
  end

  resources :favorites, only: [ :index ]

  # ====== Auth ======
  resources :users, only: %i[new create]
  resource :user_session, only: %i[new create destroy]

  # ====== Search History ======
  resources :search_sessions, only: %i[index show]

  # ====== case note ======
  resources :case_notes, only: [:index]

  # ====== Auth (OAuth / OmniAuth) ======
  get "/auth/:provider/callback", to: "oauths#create"
  get "/auth/failure",            to: "oauths#failure"
end
