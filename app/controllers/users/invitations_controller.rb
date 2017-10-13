class Users::InvitationsController < Devise::InvitationsController
  before_action :configure_invite_params, only: [:create, :update]

  def new
    self.resource = resource_class.new

    @invite_users = current_user.invite_users

    render :new
  end

  protected

    # If you have extra params to permit, append them to the sanitizer.
    def configure_invite_params
      devise_parameter_sanitizer.permit(:invite, keys: [:role])
      devise_parameter_sanitizer.permit(:accept_invitation, keys: [:locale, :mobile_no, :first_name, :last_name])
    end
end
