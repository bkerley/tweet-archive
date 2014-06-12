Rails.application.routes.draw do
  resources :tweets do
    collection do
      get 'search'
      get 'geo'
    end
  end
end
