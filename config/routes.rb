Rails.application.routes.draw do
  resources :fifa_teams
  get 'sessions/new'
  resources :teams
  root 'pages#index'

  resources :pages, only: [:index, :show, :new, :edit, :create, :update]
  resources :sessions, only: [:new, :create, :destroy]
  resources :tournaments, only: [:new, :create, :index, :show] do
    resources :teams, only: [:index, :show, :new, :edit, :create, :update, :destroy]
    resources :games, only: [:new, :create, :update]
  end
end
