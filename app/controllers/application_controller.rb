class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :send_user_to_reset_password_path

  def current_organization_user
    if session[:organization_user_id].present?
      User.find(session[:organization_user_id])
    else
      user = current_user.merchant? ? current_user : current_user.reverse_user_invitations.accept.first.sender
      session[:organization_user_id] = user.id
      user
    end
  end
  helper_method :current_organization_user

  def current_organization_name
    current_organization_user.try(:organization_name)
  end
  helper_method :current_organization_name

  def send_user_to_reset_password_path
    if (controller_name != 'reset_passwords') && ((controller_name != 'sessions' ) && (action_name != 'destroy')) &&  user_signed_in? && current_user.tmp_pasword_status
      redirect_to edit_reset_passwords_path
    end
  end


  def after_sign_in_path_for(resource)
    if resource.class.name == "AdminUser"
      admins_root_path
    elsif resource.merchant.present? && resource.sign_in_count == 1 && !resource.tmp_pasword_status
      new_user_invitation_path
    elsif resource.tmp_pasword_status
      edit_reset_passwords_path
    else
      root_path
    end
  end
end
