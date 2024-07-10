Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }
  root 'home#index'
  resources :tickets do
    resources :comments, only: [:create, :destroy]
    member do
      patch :assign
    end
  end
end
