class ResponseMessage < ApplicationRecord

  translates :message

  enum message_types: {
    new_merchant: 'Response for new Merchant',
    exist_merchant: "Response for Aplicant",
    error_in_merchant_id: 'Response if error in Merchant ID',
    blank_merchant_id: "Response if merchant ID not present"
  }

  MARKUP_VARIABLES = { sign_up_link: "sign_up_link",
  type_form_link: 'type_form_link' }

  validates_presence_of :message_type, :message
end
