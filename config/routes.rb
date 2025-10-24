# Rails.application.routes.draw do
#   devise_for :users, path: '', path_names: {
#     sign_in: 'login',
#     sign_out: 'logout',
#     registration: 'signup'
#   },
#   controllers: {
#     sessions: 'users/sessions',
#     registrations: 'users/registrations'
#   }

#   get 'verses/search'
# end




Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'auth/login', to: 'auth#login'
      post 'auth/signup', to: 'auth#signup'
      delete 'auth/logout', to: 'auth#logout'
      post 'auth/password', to: 'passwords#create'
      resources :verses do
        collection do
          get 'search'
        end
      end
      resources :subscriptions, only: [:create, :cancel]
      post 'webhooks/stripe', to: 'webhooks#stripe'
      post 'webhooks/apple', to: 'webhooks#apple'
      post 'webhooks/google', to: 'webhooks#google'
    end
  end

    get 'verses/search'
end
