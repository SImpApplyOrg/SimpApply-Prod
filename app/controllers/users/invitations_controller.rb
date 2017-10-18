class Users::InvitationsController < Devise::InvitationsController
  before_action :configure_invite_params, only: [:create, :update]
  before_action :set_user_invite, only: [:edit, :update]
  prepend_before_action :resource_from_invitation_token, :only => [:edit, :destroy]


  def new
    self.resource = resource_class.new

    @user_invitations  = current_user.user_invitations
    render :new
  end

  def edit
    sign_out send("current_#{resource_name}") if send("#{resource_name}_signed_in?")
    set_minimum_password_length
    resource.invitation_token = @user_invite.receiver.invitation_token
    render :edit
  end


  def update
    raw_invitation_token = update_resource_params[:invitation_token]
    #accept_resource
    self.resource = User.where(invitation_token: raw_invitation_token).first

    self.resource.assign_attributes(update_resource_params.except!('invitation_token').merge!({temp_invitation_token: @user_invite.token}))

    self.resource.accept_invitation!

    invitation_accepted = resource.errors.empty?

    yield resource if block_given?
    if invitation_accepted
      if Devise.allow_insecure_sign_in_after_accept
        flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
        set_flash_message :notice, flash_message if is_flashing_format?
        sign_in(resource_name, resource)
        respond_with resource, :location => after_accept_path_for(resource)
      else
        set_flash_message :notice, :updated_not_active if is_flashing_format?
        respond_with resource, :location => new_session_path(resource_name)
      end
    else
      resource.invitation_token = raw_invitation_token
      respond_with_navigational(resource){ render :edit }
    end
  end

  protected

    # If you have extra params to permit, append them to the sanitizer.
    def configure_invite_params
      devise_parameter_sanitizer.permit(:invite, keys: [:user_role] )
      devise_parameter_sanitizer.permit(:accept_invitation, keys: [:locale, :mobile_no, :first_name, :last_name, :temp_invitation_token])
    end

    def resource_from_invitation_token
      unless params[:invitation_token] && set_user_invite
        set_flash_message(:alert, :invitation_token_invalid) if is_flashing_format?
        redirect_to after_sign_out_path_for(resource_name)
      else
        unless @user_invite.receiver.invitation_accepted_at.blank?
          set_flash_message(:alert, :one_invitation_accepted) if is_flashing_format?
          redirect_to after_sign_out_path_for(resource_name)
        end
      end

      self.resource = User.where(invitation_token: @user_invite.receiver.invitation_token).first
    end

    def invite_resource(&block)
      @user = User.find_by(email: invite_params[:email])
      # @user is an instance or nil
      if @user && @user.email != current_user.email
        # invite! instance method returns a Mail::Message instance
        @user.invite!(current_user) do |u|
          u.user_role = invite_params[:user_role]
          u.skip_invitation = true
        end
        # return the user instance to match expected return type
        @user
      else
        # invite! class method returns invitable var, which is a User instance
        resource_class.invite!(invite_params, current_inviter) do |u|
          u.skip_invitation = true
        end
      end
    end

    def after_invite_path_for(current_inviter, resource)
      new_user_invitation_path
    end

    def after_invite_path_for(current_inviter)
      new_user_invitation_path
    end

  private

    # def invite_resource
    # ## skip sending emails on invite
    #   super do |u|
    #     u.skip_invitation = true
    #   end
    # end

    def set_user_invite
      @user_invite = UserInvitation.find_by_token(params[:invitation_token])
    end
end
