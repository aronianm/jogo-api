Rails.application.routes.draw do
  resources :matchups do 
    collection do 
      get :challenges
    end
    member do
      post :update_scores
    end
  end

  resources :seasons
  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  },
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  resources :users do 
    post :check_user, on: :collection
    get :primary_user, on: :collection
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

end
