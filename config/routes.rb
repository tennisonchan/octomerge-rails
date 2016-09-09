Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  resources :auto_merges, only: [:index, :show, :create, :destroy]

  root to: 'auto_merges#index'
end
