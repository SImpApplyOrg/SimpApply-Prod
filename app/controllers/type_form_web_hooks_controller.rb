class TypeFormWebHooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :check_application_token, only: [:create_application]

  def get_type_form
    sign_out current_user

    applicant_token = params[:token] || ""
    @applicant = Applicant.where(token: applicant_token).first
    flash.now[:error] = "Invalid Token, Please try again with valid token" unless @applicant
  end

  def create_application
    questions = params[:type_form_web_hook][:form_response][:definition][:fields].to_json.to_s
    answers = params[:type_form_web_hook][:form_response][:answers].to_json.to_s

    question_answers = ParseTypeFormResponse.new(questions, answers).get_question_answers

    applicant_attribute_hash = { full_response: get_params.to_json.to_s, questions: questions, answers: answers, question_answers: question_answers.to_json.to_s, token: nil }

    if @applicant.update_attributes(applicant_attribute_hash)
      merchants = @applicant.merchants

      message_for_applicant = MessageResponse.new('applicant_exist', nil, @applicant).get_message
      merchants.each do |merchant|
        if merchant.mobile_no.present?
          message_for_merchant = MessageResponse.new('new_application', merchant, @aplicant).get_message
          TwilioResponse.new(message_for_merchant, merchant.mobile_no).send_response
        else
          MerchantMailer.get_application(merchant.id, @applicant.id).deliver
        end
      end

      TwilioResponse.new(message_for_applicant, @applicant.mobile_no).send_response
    else
      message = MessageResponse.new('error_in_submit_applicant', nil, @applicant).get_message
      TwilioResponse.new(message, @applicant.mobile_no).send_response
    end

    ApplicantMailer.send_resume(@applicant.id).deliver_now

    redirect_to root_path, notice: 'Job Application successfully updated'
  end

  private
    def get_params
      params.require(:type_form_web_hook).permit!()
    end

    def check_application_token
      application_token = get_params[:form_response][:hidden][:application_token]

      @applicant = Applicant.where(token: application_token).first

      redirect_to root_path, error: 'No Application found.' if @applicant.blank?
    end
end
