Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api, constraints: { format: "json" } do
    namespace :v1 do
      resources :vouchers, only: [ :create ]
      resources :classrooms, only: [ :create, :update, :index ]
      namespace :student do
        resources :subscriptions, only: [ :create, :index, :update ] do
          collection do
            get :search
          end
        end
      end
      namespace :user do
        resources :registrations, only: [ :create, :update ] do
          collection do
            get :search
          end
        end
        resources :sessions, only: [ :create, :destroy ]
      end
    end
  end
end
