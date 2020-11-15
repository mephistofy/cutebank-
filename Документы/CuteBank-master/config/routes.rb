# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  resources :main, only: [:index] 

  resources :about, only: [:index] 

  resources :admin, only: [:index, :create]

  resources :user, only: [:index, :create]

  root to: 'main#index'

end
