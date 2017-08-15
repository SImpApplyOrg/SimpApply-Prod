require 'twilio-ruby'

# put your own credentials here
account_sid = Rails.application.secrets.twilio_sid
auth_token = Rails.application.secrets.twilio_auth_token

Twilio.configure do |config|
  config.account_sid = account_sid
  config.auth_token = auth_token
end

# and then you can create a new client without parameters
TWILIO_CLIENT = Twilio::REST::Client.new
