Gritter::Application.routes.draw do
  resources :grits
  resources :sessions, only: [:new, :create, :destroy]
  resources :registrations, only: [:new, :create]
  resources :users, only: [:index, :show, :edit, :update]

  get 'sign_in', to: 'sessions#new', as: 'sign_in'
  get 'sign_out', to: 'sessions#destroy', as: 'sign_out'

  root to: 'grits#index'

end
