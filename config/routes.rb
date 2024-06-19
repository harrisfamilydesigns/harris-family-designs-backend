Rails.application.routes.draw do
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  devise_for :users,
    path: 'api/v1/d',
    controllers: {
      sessions: 'api/v1/devise/sessions',
      registrations: 'api/v1/devise/registrations',
      confirmations: 'api/v1/devise/confirmations',
      passwords: 'api/v1/devise/passwords',
    },
    defaults: { format: :json }

  namespace :api do
    namespace :v1 do
      resources :uploads, only: [:create] do
        member do
          get :public
        end
      end
      resources :thrifters
      resources :posts, only: [:index]

      get 'stripe_accounts/current', to: 'stripe_accounts#current', as: :current_stripe_account
      post 'stripe_accounts/account_link', to: 'stripe_accounts#account_link', as: :stripe_account_link
      # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

      get 'users/current', to: 'users#current', as: :current_user
      match 'users/current', to: 'users#update_current', via: [:put, :patch]
    end
  end

  # Defines the root path route ("/")
  root "posts#index"
end
