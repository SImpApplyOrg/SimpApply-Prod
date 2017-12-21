class ResponseMessage < ApplicationRecord

  translates :message

  enum message_type: {
    new_merchant: 'Response for new Merchant',
    exist_merchant: "Response for Applicant",
    error_in_merchant_id: 'Response for Merchant ID not in proper format',
    blank_merchant_id: "Response for Merchant ID not present",
    new_application_form: "Response for getting new application form",
    view_application_form: "Response for merchant reviewed application form",
    applicant_exist: 'Response for applicant present',
    error_in_email: "Response for email not in proper format",
    error_in_submit_applicant: 'Response for not submit applicant information',
    invite_manager: 'Response for Manager',
    invite_reviewer: 'Response for Reviewer',
    mobile_verification_code_message: 'Message for send mobile verification code',
    temp_password_reset: 'Response for set temporary password'
  }

  validates_presence_of :message_type, :message
  validates_uniqueness_of :message_type
end
