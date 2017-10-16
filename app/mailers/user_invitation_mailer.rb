class UserInvitationMailer < ApplicationMailer

  default(
    from: "no-reply@simp-apply.com"
  )

  def send_invitation(user_invitation_record)
    @user_invitation = user_invitation_record
    @user = @user_invitation.receiver
    @token = @user_invitation.token
    mail(to: @user.email, subject: "Invitation instructions")
  end
end