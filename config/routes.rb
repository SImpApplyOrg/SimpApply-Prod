Rails.application.routes.draw do

  devise_for :admin_users, path: '/admins'

  devise_for :users

  namespace :admins do
    resources :default_settings, only: :update

    resources :response_messages

    resources :merchants, only: :index do
      get :active
      get :suspend
    end

    root "welcome#index"
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :twilio_web_hooks, only: :nil do
    collection do
      get :request_merchant
    end
  end

  resources :type_form_web_hooks, only: :nil do
    collection do
      post :create_application
    end
  end

  root "welcome#index"
end
