class JobApplicationsController < ApplicationController
  before_action :authenticate_user!

  before_action :get_view_screen

  def index
    if @view_screen && !@active_tabs.blank?
      @job_applications = current_user.job_applications.completed_applications

      if current_user.is_trail_account?
        max_limit = DefaultSetting.first.default_max_application_limit_for_trail_merchant

        @upgrade_account_message = I18n.t('.upgrade_account_message', default: I18n.t('paragraph.upgrade_account_message', max_limit: max_limit, upgrade_link: link_to('Upgrade Account', "javascript:;"))).html_safe if @job_applications.size > max_limit

        @job_applications = @job_applications.limit(@max_limit)
      end
    else
      @no_view_screen_available_message = I18n.t('no_view_screen_available', default: I18n.t('paragraph.no_view_screen_available'))
    end
  end

  def show
    @job_application = JobApplication.find_by_token(params[:id])

    unless @job_application.is_reviewed?
      applicant = @job_application.applicant
      merchant = applicant.merchant
      @job_application.update_attributes(is_reviewed: true)

      message = MessageResponse.new(merchant.token, 'view_application').get_message
      TwilioResponse.new(message, applicant.mobile_no).send_response
    end
  end

  private
    def get_view_screen
      @view_screen = ViewScreen.active.first
      @active_tabs = @view_screen.screen_tabs.active if @view_screen
    end
end
