class TwilioWebHooksController < ApplicationController

  def request_merchant
    merchant, @message_type = Merchant.get_merchant_and_message_type(get_params)

    token, mobile_no = case @message_type
    when "blank", "error", "email_error"
      ['', params[:From]]
    when "exist", "email_exist", "email_new"
      @mail_message_type = @message_type

      get_applicant_token_and_mobile_no(merchant)
    else
      [merchant.token, merchant.mobile_no]
    end

    merchant.send_mail(@mail_message_type, @applicant.id) if ["email_exist", "email_new"].include?(@mail_message_type)
    message = MessageResponse.new(@message_type, merchant, @applicant).get_message

    TwilioResponse.new(message, mobile_no).send_response
  end

  private
    def get_params
      params.permit(:Body, :From)
    end

    def get_applicant_token_and_mobile_no(merchant)
      @applicant = Applicant.find_or_create_by(mobile_no: get_params[:From])
      if @applicant.have_details?
        @applicant.create_job_application(merchant)
        @message_type = 'applicant_exist'
        return ['', @applicant.mobile_no]
      else
        @applicant.generate_token_and_create_job_application(merchant)
        @message_type = 'exist'
        return [@applicant.token, @applicant.mobile_no]
      end
    end
end
