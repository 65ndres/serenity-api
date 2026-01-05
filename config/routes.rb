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
      post 'auth/password/verify', to: 'passwords#verify_code'
      put 'auth/password', to: 'passwords#update'
      patch 'auth/password', to: 'passwords#update'
      resources :verses do
        collection do
          get 'search'
          get 'search_by_address'
        end
        member do
          post 'toggle_like'
        end
      end

      post 'conversation/new', to: 'conversations#new'

      resources :conversations, only: [] do
        resources :messages, only: [:index, :create]
        get 'admin_conversation', to: 'conversations#admin_conversation'
      end


      get 'liked', to: 'verses#liked'
      resources :subscriptions, only: [:create, :cancel]
      post 'webhooks/stripe', to: 'webhooks#stripe'
      post 'webhooks/apple', to: 'webhooks#apple'
      post 'webhooks/google', to: 'webhooks#google'
      get 'user', to: 'users#show'
      post 'user', to: 'users#update'
      get 'users/search', to: 'users#search'
      get 'user/conversations', to: 'conversations#index'
    end
  end

    get 'verses/search'
end
