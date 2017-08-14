class Admins::ApplicationController < ApplicationController
  protect_from_forgery with: :exception

  layout "admin_application"

  before_action :authenticate_admin_user!
end
