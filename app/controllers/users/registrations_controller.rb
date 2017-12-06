class Users::RegistrationsController < Devise::RegistrationsController
  layout :resolve_layout

  before_action :configure_sign_up_params, only: [:create, :update]
  before_action :authenticate_merchant_token, only: [:new, :create]
  before_action :bypass_token, only: :create

  # GET /resource/sign_up
  def new
    if @merchant
      build_resource({token: @merchant.token, email: @merchant.email, mobile_no: @merchant.mobile_no})
      yield resource if block_given?
      respond_with resource
    else
      super
    end
  end

  protected

    # If you have extra params to permit, append them to the sanitizer.
    def configure_sign_up_params
      devise_parameter_sanitizer.permit(:sign_up, keys: [:locale, :token, :mobile_no, :first_name, :last_name, :organization_name, :is_merchant, :address, :lat, :lng])
      devise_parameter_sanitizer.permit(:account_update, keys: [:locale, :token, :mobile_no, :first_name, :last_name, :organization_name, :is_merchant, :address, :lat, :lng])
    end

    def after_sign_up_path_for(resource)
      resource.merchant.present? ? new_user_invitation_path(wizard: true) : super
    end

    def authenticate_merchant_token
      unless params[:token].blank?
        @merchant = Merchant.where(token: params[:token]).first
        flash[:error] = "Invalid token" if @merchant.blank?
        redirect_to root_path if flash[:error]
      end
    end

    def bypass_token
      if params[:token].blank?
        merchant = Merchant.create(
              uuid: params[:user][:merchant_code],
              mobile_no: params[:user][:mobile_no])
        params[:user][:token] = merchant.token
      end
    end

  private

    def resolve_layout
      if action_name == "new"
        'signup_wizard_application'
      else
        'application'
      end
    end
end


