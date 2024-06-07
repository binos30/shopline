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
               sessions: "sessions"
             },
             path_names: {
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
    resources :orders, only: %i[index show]
  end

  scope module: "site" do
    resources :categories, only: :show, param: :slug
    resources :products, only: :show, param: :slug
  end
end
