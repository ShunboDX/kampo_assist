Rails.application.routes.draw do
  get "searches/step1"
  get "searches/step2"
  get "/search/results", to: "searches#results", as: :search_results
  resources :kampos, only: [ :show ]
  # ====== Health Check ======
  get "up" => "rails/health#show", as: :rails_health_check

  # ====== Home ======
  get "home/index"
  root "home#index"

  # ====== Search Flow ======
  resource :search, only: [] do
    get :step1
    get :step2
    get :results
  end
end
