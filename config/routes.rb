Rails.application.routes.draw do

  require 'sidekiq/web'
  # ...
  mount Sidekiq::Web, at: '/sidekiq'

  devise_for :admin_users, path: '/admins'

  devise_for :users, controllers: { registrations: 'users/registrations', invitations: 'users/invitations' }

  namespace :admins do
    resources :default_settings, only: :update

    resources :response_messages

    resources :reminder_messages

    resources :message_tags

    resources :merchants, only: :index do
      get :active
      get :suspend
    end

    resources :applicants, only: [:index, :edit, :update, :destroy]

    resources :job_application_questions, only: [:index, :update] do
      collection do
        get :fetch_questions
        delete :destroy_all
      end
    end

    resources :view_screens

    root "welcome#index"
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :twilio_web_hooks, only: :nil do
    collection do
      get :request_merchant
    end
  end

  resources :user_invites, only: [:destroy] do
    member do
      get :update_token
    end
  end

  resources :users, only: nil do
    collection do
      post :check_mobile_no
      post :send_verification_code
      post :check_verfication_code
      post :check_merchant_code
      post :check_email
      get  :invitations
    end
  end

  resources :type_form_web_hooks, only: :nil do
    collection do
      get :get_type_form
      post :create_application
    end
  end

  resources :applicants, only: [:index, :show]

  resources :reset_passwords, only: :nil do
    collection do
      get :edit
      patch :update_password
    end
  end


  patch '/update_organization_name', to: "welcome#update_organization_name"
  get '/set_organization', to: 'welcome#set_organization'

  root "welcome#index"
end
