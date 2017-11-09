class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def current_organization_user
    User.find(session[:organization_user_id]) rescue nil
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
