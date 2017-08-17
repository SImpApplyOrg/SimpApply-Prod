class JobApplicationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @job_applications = current_user.job_applications.completed_applications

    if current_user.is_trail_account?
      max_limit = DefaultSetting.first.default_max_application_limit_for_trail_merchant

      @job_applications = @job_applications.limit(max_limit)
    end
  end

  def show
    @job_application = JobApplication.find_by_token(params[:id])

    unless @job_application.is_reviewed?
      applicant = @job_application.applicant
      merchant = applicant.merchant
      @job_application.update_attributes(is_reviewed: true)

      message = MessageResponse.new(merchant.token, 'view_application').get_message
      TwilioResponse.new(message, applicant.mobile_no).get_response
    end
  end
end
