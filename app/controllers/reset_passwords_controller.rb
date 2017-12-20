class ResetPasswordsController < ApplicationController
  before_action :authenticate_user!

  def edit 
    @user = current_user
  end

  def update_password
    @user = current_user
    if @user.update_attributes(user_params.merge!("tmp_pasword_status"=> false))
      bypass_sign_in(@user)
      redirect_to root_path, notice: 'password updated successfully'
    else
      flash[:error] = 'There is something went worng!'
      render :edit
    end
  end


  private
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end
end
