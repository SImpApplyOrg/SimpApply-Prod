class TwilioWebHooksController < ApplicationController

  def request_merchant
    # content_type 'text/xml'

    merchant, message_type = Merchant.get_merchant(get_params)
    message = MessageResponse.new(merchant, message_type).get_message

    TwilioResponse.new(message).get_response
  end

  private
    def get_params
      params.permit(:Body, :From)
    end
end
