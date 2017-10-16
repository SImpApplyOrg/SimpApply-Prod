class UserInvitationsController < ApplicationController
  before_action :set_user_invite, only: [:check_accept]

  def check_accept
    if @user_invite.update_attributes(status: "accepted")
      @receiver = @user_invite.receiver
      redirect_to accept_invitation_path(@receiver, :invitation_token => @receiver.invitation_token)
    else
      flash[:error] = "User Invitation not accepted"
    end
  end

  private

    def set_user_invite
      @user_invite = UserInvitation.where(token: params[:token]).first
    end
end
