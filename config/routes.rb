Rails.application.routes.draw do
  devise_for :users
  root to: "movies#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  resources :movies, only: [:index, :show] do
    resources :reviews, only: [:index, :create, :new]
  end

  resources :sharings, only: [:index, :update] do
    resources :messages, only: [:index, :create, :new]
    resources :attendees, only: [:create, :new, :destroy]
  end

  resources :sharings, only: [:show, :create] do
    resources :messages, only: :create
  end

end
