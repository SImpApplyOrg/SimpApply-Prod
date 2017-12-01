class WelcomeController < ApplicationController
  layout :resolve_layout

  def index
    @invitations = current_user.reverse_user_invitations.pending if current_user
  end

  def update_organization_name
    current_user.update_attributes(user_params)
  end

  def set_organization
    session[:organization_user_id] = params[:organization_user_id]
  end

  private
    def user_params
      params.require(:user).permit(:organization_name, :edit_organization)
    end

    def resolve_layout
      if action_name == "index"
        'signup_wizard_application'
      else
        'application'
      end
    end
end
