class ResponseMessage < ApplicationRecord

  translates :message

  enum message_type: {
    new_merchant: 'Response for new Merchant',
    exist_merchant: "Response for Aplicant",
    error_in_merchant_id: 'Response for Merchant ID not in proper format',
    blank_merchant_id: "Response for Merchant ID not present",
    new_application_form: "Response for getting new application form",
    view_application_form: "Response for merchant reviewed application form"
  }

  MARKUP_VARIABLES = { sign_up_link: "sign_up_link",
  type_form_link: 'type_form_link' }

  validates_presence_of :message_type, :message
  validates_uniqueness_of :message_type
end
