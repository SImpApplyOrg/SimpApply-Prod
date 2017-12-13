class Users::InvitationsController < Devise::InvitationsController
  before_action :configure_invite_params, only: [:create, :update]
  before_action :set_user_invite, only: [:edit, :update]
  before_action :get_user_invitations, only: [:new, :create]
  before_action :check_organization, only: [:new]
  prepend_before_action :resource_from_invitation_token, :only => [:edit, :destroy]

  def new
    self.resource = resource_class.new(user_role: 'manager')
    if params[:wizard]
      render :new_by_wizard, layout: 'signup_wizard_application'
    else
      render :new
    end
  end

  def edit
    sign_out send("current_#{resource_name}") if send("#{resource_name}_signed_in?")
    set_minimum_password_length
    resource.invitation_token = @user_invite.receiver.invitation_token
    render :edit
  end

  def create
    self.resource = invite_resource
    resource_invited = resource.errors.empty?

    yield resource if block_given?

    if resource_invited
      if is_flashing_format? && self.resource.invitation_sent_at
        set_flash_message :notice, :send_instructions, :email => self.resource.email
      end
      respond_to do |format|
        format.json { render json: resource, status: :created  }
        format.html { respond_with resource, :location => new_user_invitation_path }
      end
    else
      flash[:error] = resource.errors.full_messages.join('<br>')
      respond_to do |format|
        format.json { render json: resource.errors, status: :unprocessable_entity  }
        format.html { respond_with_navigational(resource) { render :new } }
      end
      
    end
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
      devise_parameter_sanitizer.permit(:invite, keys: [:user_role, :mobile_no] )
      devise_parameter_sanitizer.permit(:accept_invitation, keys: [:locale, :mobile_no, :first_name, :last_name, :temp_invitation_token, :is_merchant])
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
      invite_for = current_organization_user || current_user
      @user = User.find_by(mobile_no: invite_params[:mobile_no])
      # @user is an instance or nil
      if @user
        if !current_user.merchant? && @user.mobile_no == current_organization_user.mobile_no
          @user.errors.add(:base, :not_invite_organisation_owner)
          return @user
        end
        if @user.mobile_no == current_user.mobile_no
          @user.errors.add(:base, :not_invite_yourself)
        else
          user_inivitation = UserInvitation.where(sender_id: invite_for.id, receiver_id: @user.id).first
          unless user_inivitation
            UserInvitation.create(sender_id: invite_for.id, receiver_id: @user.id, role: invite_params[:user_role])
            flash[:notice] = "Invitation sent to mobile: #{invite_params[:mobile_no]}"
          else
            @user.errors.add(:base, :already_sent_invitation)
          end
        end
      else
        # invite! class method returns invitable var, which is a User instance
        if !Phonie::Phone.parse(invite_params[:mobile_no])
          @user = User.new(invite_params)
          @user.errors.add(:mobile_no, "is not a valid number.")
        else
          invite_parameters = invite_params.merge!(email: "#{SecureRandom.hex(5)}@xyz.com")
          resource = resource_class.invite!(invite_parameters, current_inviter) do |u|
            u.invite_for_id = invite_for.id
            u.skip_invitation = true
          end
          flash[:notice] = "Invitation sent to mobile: #{invite_params[:mobile_no]}"
        end
      end
      @user || resource
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

    def get_user_invitations
      user = current_organization_user || current_user
      @user_invitations  = user.user_invitations
    end

    def check_organization
      if current_user.merchant? && current_user.organization_name.blank?
        flash[:error] = "Please set your organization name before invite users."
        redirect_to root_path
      elsif !current_user.merchant? && !(current_organization_user.present? && (current_user.manager?(current_organization_user) || current_user.reviewer?(current_organization_user)))
        flash[:error] = "You are not athorize to access the Manage Account page."
        redirect_to root_path
      end
    end
end
