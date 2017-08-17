class JobApplicationsController < ApplicationController
  def index
    @job_applications = if current_user.is_trail_account?
      JobApplication.limit(DefaultSetting.first.default_max_application_limit_for_trail_merchant)
    else
      JobApplication.all
    end
  end

  def show
    @job_application = JobApplication.find(params[:id])
    applicant = @job_application.applicant
    merchant = applicant.merchant

    message = MessageResponse.new(merchant.token, 'view_application').get_message

    TwilioResponse.new(message, applicant.mobile_no).get_response
  end
end
