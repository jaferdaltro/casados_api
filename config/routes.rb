require "sidekiq/web"

Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq" # mount Sidekiq::Web in your Rails app

  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api, constraints: { format: "json" } do
    namespace :v1 do
      resources :vouchers, only: [ :create ]
      resources :classrooms, only: [ :create, :update, :index ]
      namespace :student do
        resources :payments do
          collection do
            post :create_credit_card
            post :create_pix
            post :webhook
            get :payment_status
          end
        end
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
