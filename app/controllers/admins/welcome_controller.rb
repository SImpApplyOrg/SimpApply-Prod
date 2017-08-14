class Admins::WelcomeController < Admins::ApplicationController

  def index
    @default_setting = DefaultSetting.first
  end
end
