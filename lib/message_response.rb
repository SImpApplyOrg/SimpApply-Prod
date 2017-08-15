class MessageResponse

  def initialize(merchant, message_type)
    @merchant = merchant
    @message_type = message_type
  end

  def get_message
    case @message_type
    when 'new'
      message_for_new
    when 'exist'
      message_for_exsit
    when 'error', 'blank'
      message_for_error_and_blank
    end
  end

  private
    def message_for_error_and_blank
      "Please send the message in proper format. Merchant ID could be alphanumeric, min-length-5, max-length-10."
    end

    def message_for_new
      "Hi, open this url http://localhost:3000/users/sign_up?token=#{@merchant.token} and fillup the from"
    end

    def message_for_exsit
      "Hi, Fillup the application by accessing the url #{}"
    end
end