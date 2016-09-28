Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#index'

  get '/auth/slack/callback', to: 'slack#admin_login'

  resources :admin, only: [:index] do
    get :configuration, on: :collection
    get :login, on: :collection
  end

  resources :superadmin, only: [:index] do
    get :login, on: :collection
    post :login_attempt, on: :collection
  end

  post 'slack', to: 'slack#incoming_event'
end
