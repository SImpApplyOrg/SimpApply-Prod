Rails.application.routes.draw do

  devise_for :admin_users, path: '/admins'

  devise_for :users

  namespace :admins do
    resources :default_settings, only: :update

    resources :response_messages

    root "welcome#index"
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :twilio_web_hooks, only: :nil do
    collection do
      get :request_merchant
    end
  end

  root "welcome#index"
end
