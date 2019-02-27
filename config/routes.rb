Rails.application.routes.draw do
  devise_for :users
  namespace :api, defaults: { format: :json } do
    scope module: :v1 do
      resources :users, only: [:show, :create, :update, :destroy] do
        resources :toys, only: [:create, :update, :destroy]
      end
      resources :sessions, only: [:create, :destroy]
      resources :toys, only: [:show, :index]
    end
  end
  root to: 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
