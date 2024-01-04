# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  scope :authorization do
    get '' => 'authorization#index'
    post 'login' => 'authorization#login'
    post 'logout' => 'authorization#logout'
  end

  scope :home do
    get '' => 'home#index'
  end

  # Errors
  get '/403', to: 'error#forbidden'
  get '/404', to: 'error#not_found'
  get '/500', to: 'error#internal_server_error'
  match '*path', to: 'error#catch_unrecognized', via: :all
end
