class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def after_sign_in_path_for(resource)
    resource.class.name == "AdminUser" ? admins_root_path : root_path
  end
end
