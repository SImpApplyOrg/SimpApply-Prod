class Admins::DefaultSettingsController < Admins::ApplicationController

  def update
    @default_setting = DefaultSetting.first

    if @default_setting.update_attributes(default_setting_params)
      redirect_to admins_root_path, notice: "Setting updated"
    else
      flash[:error] = "There was some erorr in update setting"
      render template: 'admins/welcome/index'
    end
  end

  private
    def default_setting_params
      params.require(:default_setting).permit(:max_applicant_size)
    end
end
