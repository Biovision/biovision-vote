Rails.application.routes.draw do
  resources :votes, only: :destroy, defaults: { format: :json }

  scope '(:locale)', constraints: { locale: /ru|en|sv/ } do
    resources :votes, only: :create, defaults: { format: :json }

    namespace :admin do
      resources :votes, only: :index
    end
  end
end
