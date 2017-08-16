class TypeFormWebHooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :check_application_token

  def create_application
    questions = params[:type_form_web_hook][:form_response][:definition][:fields]
    answers = params[:type_form_web_hook][:form_response][:answers]

    @job_application.update_attributes(full_response: get_params, questions: questions, answers: answers)

    merchant = @job_application.applicant.merchant
    message = MessageResponse.new(merchant.token, 'new_application').get_message

    TwilioResponse.new(message, merchant.mobile_no).get_response

    redirect_to root_path, notice: 'Job Application successfully updated'
  end

  private
    def get_params
      params.require(:type_form_web_hook).permit!()
    end

    def check_application_token
      application_token = get_params[:form_response][:hidden][:application_token]

      @job_application = JobApplication.where(token: application_token).first

      redirect_to root_path, error: 'No Application found.' if @job_application.blank?
    end
end