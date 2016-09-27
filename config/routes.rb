Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#index'

  resources :admin, only: [:index] do
    get :login, on: :collection
  end

  post 'slack', to: 'slack#incoming_event'
end
