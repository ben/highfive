Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#index'

  resources :slack_auth, only: :index

  resources :admin, only: :index do
    collection do
      get :configuration
      get :login
      get :highfives
      get :fundings

      resource :tangocard, only: [] do
        member do
          post :enable
          post :credit_card
          patch :settings
        end
      end
    end
    collection do
    end
  end

  resources :superadmin, only: [:index] do
    get :login, on: :collection
    post :login_attempt, on: :collection
    post :impersonate, on: :collection
  end

  post '/slack/command', to: 'slack#command'
  post '/slack/interact', to: 'slack#interact'

  mount Resque::Server.new, at: '/resque'
end
