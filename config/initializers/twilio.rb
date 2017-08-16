require 'twilio-ruby'

# put your own credentials here

Twilio.configure do |config|
  config.account_sid = ENV['twilio_sid']
  config.auth_token = ENV['twilio_auth_token']
end

# and then you can create a new client without parameters
TWILIO_CLIENT = Twilio::REST::Client.new
