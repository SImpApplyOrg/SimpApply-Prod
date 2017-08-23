class TypeFormWebHooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :check_application_token

  def create_application
    questions = params[:type_form_web_hook][:form_response][:definition][:fields].to_json.to_s
    answers = params[:type_form_web_hook][:form_response][:answers].to_json.to_s

    question_answers = ParseTypeFormResponse.new(questions, answers).get_question_answers

    @job_application.update_attributes(full_response: get_params.to_json.to_s, questions: questions, answers: answers, question_answers: question_answers.to_json.to_s)

    merchant = @job_application.applicant.merchant
    message = MessageResponse.new(merchant.token, 'new_application').get_message

    TwilioResponse.new(message, merchant.mobile_no).send_response

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
