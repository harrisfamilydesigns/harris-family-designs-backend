Rails.application.routes.draw do

  # handle subdomains
  constraints subdomain: ['www', 'secondhand'] do
    get "(*path)", to: "application#serve_from_gcs"
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  devise_for :users,
           controllers: {
             sessions: 'users/sessions',
             registrations: 'users/registrations'
           },
           defaults: { format: :json }

  resources :posts, only: [:index]

  # Defines the root path route ("/")
  root "posts#index"
end
