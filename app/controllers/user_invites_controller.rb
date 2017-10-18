class UserInvitesController < ApplicationController
  before_action :set_user_invite

  def update_token
    @user_invite.send("#{params[:status]}!") if params[:status]
    redirect_to root_url
  end

  def destroy
    @user_invite.destroy
    redirect_to root_url, notice: 'User successfully removed from the organization.'
  end

  private

    def set_user_invite
      @user_invite = UserInvitation.find(params[:id])
    end
end
