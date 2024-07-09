# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", :as => :rails_health_check

  # Defines the root path route ("/")
  root "site/home#index"

  devise_for :users,
             path: "",
             controllers: {
               registrations: "users/registrations",
               sessions: "users/sessions"
             },
             path_names: {
               edit: "profile/edit",
               sign_in: "/login",
               sign_out: "/logout"
             }

  namespace :admin do
    root to: redirect("admin/dashboard")

    resources :dashboard, only: :index, constraints: { format: :html }
    resources :categories
    resources :products do
      resources :stocks
    end
    resources :orders, only: %i[index show] do
      member { put :fulfill }
    end
    resources :customers, only: :index
    resources :subscribers, only: :index
  end

  scope module: "site" do
    get "cart" => "cart#show"
    get "order/success" => "checkout#success"
    get "order/cancel" => "checkout#cancel"
    post "checkout" => "checkout#create"
    resources :categories, only: %i[index show], param: :slug
    resources :products, only: %i[index show], param: :slug
    resources :subscribers, only: %i[new create]
    resources :orders, only: %i[index show], param: :order_code
  end

  post "stripe_webhooks" => "webhooks#stripe"
end
