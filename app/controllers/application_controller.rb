class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

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

  def after_sign_in_path_for(resource)
    if resource.class.name == "AdminUser"
      admins_root_path
    elsif resource.merchant.present? && resource.sign_in_count == 1
      new_user_invitation_path
    else
      root_path
    end
  end
end
