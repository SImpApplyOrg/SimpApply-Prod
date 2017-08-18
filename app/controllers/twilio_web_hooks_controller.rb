class TwilioWebHooksController < ApplicationController

  def request_merchant
    merchant, message_type = Merchant.get_merchant(get_params)

    token, mobile_no = if message_type == "exist"
      applicant = merchant.applicants.find_or_create_by(mobile_no: get_params[:From])
      job_application = applicant.job_applications.create()
      [job_application.token, applicant.mobile_no]
    elsif message_type == "blank"
      ['', params[:From]]
    else
      [merchant.token, merchant.mobile_no]
    end
    message = MessageResponse.new(token, message_type).get_message

    TwilioResponse.new(message, mobile_no).get_response
  end

  private
    def get_params
      params.permit(:Body, :From)
    end
end
