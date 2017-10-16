class Users::InvitationsController < Devise::InvitationsController
  before_action :configure_invite_params, only: [:create, :update]
  
  prepend_before_action :resource_from_invitation_token, :only => [:edit, :destroy]


  def new
    self.resource = resource_class.new

    @invite_users = current_user.invite_users

    render :new
  end

  def edit
    sign_out send("current_#{resource_name}") if send("#{resource_name}_signed_in?")
    set_minimum_password_length
    resource.invitation_token = params[:invitation_token]
    render :edit
  end


  def update
    raw_invitation_token = update_resource_params[:invitation_token]
    self.resource = User.where(invitation_token: update_resource_params[:invitation_token]).first #accept_resource
    invitation_accepted = resource.errors.empty?

    yield resource if block_given?
    if invitation_accepted
      if Devise.allow_insecure_sign_in_after_accept
        flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
        set_flash_message :notice, flash_message if is_flashing_format?
        sign_in(resource_name, resource)
        respond_with resource, :location => after_accept_path_for(resource)
        binding.pry
      else
        binding.pry
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
      devise_parameter_sanitizer.permit(:invite, keys: [:role])
      devise_parameter_sanitizer.permit(:accept_invitation, keys: [:locale, :mobile_no, :first_name, :last_name])
    end

    def resource_from_invitation_token
      unless params[:invitation_token] && self.resource = User.where(invitation_token: params[:invitation_token]).first
        set_flash_message(:alert, :invitation_token_invalid) if is_flashing_format?
        redirect_to after_sign_out_path_for(resource_name)
      end
    end

  private

    def invite_resource
    ## skip sending emails on invite
      super do |u|
        u.skip_invitation = true
      end
    end

end
