Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'auth/login', to: 'auth#login'
      post 'auth/signup', to: 'auth#signup'
      delete 'auth/logout', to: 'auth#logout'

      # Protected routes (e.g., verses)
      resources :verses do
        collection do
          get 'search'
        end
      end
    end
  end

end
