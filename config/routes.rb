Rails.application.routes.draw do
  root to: 'homepage#index'

  resources :tweets do
    collection do
      get 'search'
      get 'geo'
      get 'census'
    end
    member do
      get 'around'
      post 'populate_references'
    end
  end

  get 'maps', to: 'maps#index', as: 'maps'
  get 'maps/*bbox', to: 'maps#show', as: 'map', format: false
end
