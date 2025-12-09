Rails.application.routes.draw do
  get "searches/step1"
  get "searches/step2"
  # ====== Health Check ======
  get "up" => "rails/health#show", as: :rails_health_check

  # ====== Home ======
  get "home/index"
  root "home#index"

  # ====== Search Flow ======
  resource :search, only: [] do
    get :step1
    get :step2
    get :step3
  end
end
