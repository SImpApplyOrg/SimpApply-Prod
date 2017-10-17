class WelcomeController < ApplicationController

  def index
    @invitations = current_user.reverse_user_invitations if current_user
  end

  def update_organization_name
    current_user.update_attributes(user_params)
  end

  private
    def user_params
      params.require(:user).permit(:organization_name)
    end
end
