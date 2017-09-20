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
    error_in_submit_applicant: 'Response for not submit applicant information'
  }

  MARKUP_VARIABLES = {
    sign_up_link: "sign_up_link",
    type_form_link: 'type_form_link',
    applicant_position: 'applicant_position',
    date_submitted: 'date_submitted',
    merchant_first_name: 'merchant_first_name',
    business_name: 'business_name',
    applicant_first_name: 'applicant_first_name',
    applicant_phone_number: 'applicant_phone_number',
    applicant_age: 'applicant_age',
    applicant_city: 'applicant_city',
    job_application_link: 'job_application_link' }

  validates_presence_of :message_type, :message
  validates_uniqueness_of :message_type
end
