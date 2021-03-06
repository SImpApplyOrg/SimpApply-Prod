class WelcomeController < ApplicationController
  layout :resolve_layout

  def index
  end

  def update_organization_name
    current_user.update_attributes(user_params)
  end

  def set_organization
    session[:organization_user_id] = params[:organization_user_id]
  end

  private
    def resolve_layout
      if (action_name == "index") && !current_user
        'signup_wizard_application'
      else
        'application'
      end
    end

    def user_params
      params.require(:user).permit(:organization_name, :edit_organization)
    end
end
