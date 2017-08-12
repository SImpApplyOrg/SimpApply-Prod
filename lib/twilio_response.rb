require 'twilio-ruby'

class TwilioResponse

  def initialize(message)
    @message = message
  end

  def get_response
    twiml = Twilio::TwiML::MessagingResponse.new do |r|
      r.message ({ body: @message })
    end

    twiml.to_s
  end

end