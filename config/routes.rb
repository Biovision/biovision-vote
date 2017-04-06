Rails.application.routes.draw do
  resources :votes, only: [:create, :destroy], defaults: { format: :json }

  namespace :admin do
    resources :votes, only: [:index]
  end
end
