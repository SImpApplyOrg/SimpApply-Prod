require 'twilio-ruby'

class TwilioResponse

  def initialize(message, mobile_no)
    @message = message
    @mobile_no = mobile_no
  end

  def get_response
    TWILIO_CLIENT.messages.create(
      from: ENV['twilio_no'],
      to: @mobile_no,
      body: @message
    )
  end

end
