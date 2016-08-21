Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  resources :auto_merges, only: [:create]

  root to: 'home#index'
end
