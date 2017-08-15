class TwilioWebHooksController < ApplicationController

  def request_merchant
    response.headers['Content-Type'] = 'text/xml'
    # content_type 'text/xml'

    object, message_type = Merchant.get_merchant(get_params)
    message = MessageResponse.new(object, message_type).get_message

    TwilioResponse.new(message, object.mobile_no).get_response
  end

  private
    def get_params
      params.permit(:Body, :From)
    end
end
