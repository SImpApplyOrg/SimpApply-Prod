class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create, :update]
  before_action :authenticate_merchant_token, only: [:new, :create]

  # GET /resource/sign_up
  def new
    build_resource({token: @merchant.token})

    # resource.mobile_no = @merchant.mobile_no
    # resource.email = @merchant.email

    yield resource if block_given?
    respond_with resource
  end
  protected

    # If you have extra params to permit, append them to the sanitizer.
    def configure_sign_up_params
      devise_parameter_sanitizer.permit(:sign_up, keys: [:locale, :token, :mobile_no, :first_name, :last_name])
      devise_parameter_sanitizer.permit(:account_update, keys: [:locale, :token, :mobile_no, :first_name, :last_name])
    end

    def after_sign_up_path_for(resource)
      new_user_invitation_path
    end

    def authenticate_merchant_token
      flash[:error] = if params[:token].blank?
        "You can't signup without token"
      else
      @merchant = Merchant.where(token: params[:token]).first
        "Invalid token" if @merchant.blank?
      end
      redirect_to root_path if flash[:error]
    end
end


