class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def after_sign_in_path_for(resource)
    if resource.sign_in_count == 1
      new_user_invitation_path
    elsif resource.class.name == "AdminUser"
      admins_root_path
    else
      root_path
    end
  end
end
