Rails.application.routes.draw do
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

  resources :kampos, only: [ :show ]
end
