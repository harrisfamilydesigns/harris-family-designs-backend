Rails.application.routes.draw do
  resources :uploads, only: [:create] do
    member do
      get :public
    end
  end
  resources :thrifters
  # handle if subdomain is NOT 'api'
  constraints subdomain: /^(?!api$).+/ do
    get "(*path)", to: "application#serve_from_gcs"
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  get 'users/current', to: 'users#current', as: :current_user
  match 'users/current', to: 'users#update_current', via: [:put, :patch]

  devise_for :users,
           controllers: {
             sessions: 'users/sessions',
             registrations: 'users/registrations',
             confirmations: 'users/confirmations',
             passwords: 'users/passwords',
           },
           defaults: { format: :json }

  resources :posts, only: [:index]

  get 'stripe_accounts/current', to: 'stripe_accounts#current', as: :current_stripe_account
  post 'stripe_accounts/account_link', to: 'stripe_accounts#account_link', as: :stripe_account_link

  # Defines the root path route ("/")
  root "posts#index"
end
