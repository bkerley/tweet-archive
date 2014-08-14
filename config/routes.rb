Rails.application.routes.draw do
  root to: 'homepage#index'

  resources :tweets do
    collection do
      get 'search'
      get 'geo'
    end
  end

  get 'maps', to: 'maps#index'
end
