class ApplicantsController < ApplicationController
  before_action :authenticate_user!

  before_action :get_view_screen

  def index
    if @view_screen && !@active_tabs.blank?
      @applicants = current_user.applicants.distinct.have_details

      if current_user.is_trail_account?
        max_limit = DefaultSetting.first.default_max_application_limit_for_trail_merchant

        @upgrade_account_message = I18n.t('.upgrade_account_message', default: I18n.t('paragraph.upgrade_account_message', max_limit: max_limit, upgrade_link: link_to('Upgrade Account', "javascript:;"))).html_safe if @applicants.size > max_limit

        @applicants = @applicants.limit(@max_limit)
      end
    else
      @no_view_screen_available_message = I18n.t('no_view_screen_available', default: I18n.t('paragraph.no_view_screen_available'))
    end
  end

  def show
    @applicant = Applicant.find(params[:id])

    unless @applicant.is_reviewed?
      @applicant.update_attributes(is_reviewed: true)

      message = MessageResponse.new('view_application', current_user.merchant, @applicant).get_message
      TwilioResponse.new(message, @applicant.mobile_no).send_response
    end
  end

  private
    def get_view_screen
      @view_screen = ViewScreen.active_screens.first
      @active_tabs = @view_screen.screen_tabs.active if @view_screen
    end
end
