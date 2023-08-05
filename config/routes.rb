Rails.application.routes.draw do
  get 'payments/:id', :to => "payments#show", :as => "payment"
  get 'payments',:to => "payments#index", :as => "payments"
  post '/payments/:loan_id/', :to => "payments#create", :as => "create"


  resources :loans, defaults: {format: :json}, only: [:index, :show] do
    # member do
      get '/payments/', :to => "loans#loan_payments", :as => "payments"
      get '/payments/:payment_id', :to => "loans#loan_payment", :as => "payment"
      post '/payments/', :to => "loans#create_payment", :as => "create_payment"
    # end
  end
end
