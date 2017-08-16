class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  before_action :authenticate_merchant_token, if: :devise_controller?

  def after_sign_in_path_for(resource)
    resource.class.name == "AdminUser" ? admins_root_path : root_path
  end

  def authenticate_merchant_token
    if params[:controller] == 'devise/registrations' && ["new", "create"].include?(params[:action])
      flash[:error] = if params[:action] == "new" && params[:token].blank?
        "You can't signup without token"
      elsif params[:action] == "create"
        merchant = Merchant.where(token: params[:user][:token]).first
        "Invalid token" if merchant.blank?
      end
      redirect_to root_path if flash[:error]
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:locale, :token])
  end
end
