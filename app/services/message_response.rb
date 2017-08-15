class MessageResponse

  def initialize(object, message_type)
    @object = object
    @message_type = message_type
  end

  def get_message
    message_type = case @message_type
    when 'new'
      "new_merchant"
    when 'exist'
      "exist_merchant"
    when 'error'
      "error_in_merchant_id"
    when 'blank'
      "blank_merchant_id"
    end

    response_message = ResponseMessage.where(message_type: message_type).first

    if response_message.blank?
      send("message_for_#{@message_type}")
    else
      customize_message(translated_mesage(response_message))
    end
  end

  private
    def customize_message(message)
      mailer_options = ResponseMessage::MARKUP_VARIABLES
      {
        sign_up_link: Rails.application.routes.url_helpers.new_user_registration_url(token: @object.token),
        type_form_link: "https://genesis18.typeform.com/to/M7Zo8Z?token=#{@object.token}"
      }.each do |key, value|
        message.gsub!(mailer_options[key], value) if message.include? mailer_options[key]
      end

      message
    end

    def translated_mesage(response_message)
      if @message_type == 'exist'
        locale = @object.user.present? ? @object.user.locale : 'en'
        Globalize.with_locale(locale.to_sym) { response_message.message }
      else
        response_message.message
      end
    end

    def message_for_error
      "Please send the message in proper format. Merchant ID could be alphanumeric, min-length-5, max-length-10."
    end

    def message_for_blank
      "Please send the message in proper format. Merchant ID could be alphanumeric, min-length-5, max-length-10."
    end

    def message_for_new
      "Hi, To become a merchant open this url #{Rails.application.routes.url_helpers.new_user_registration_url(token: @object.token)} and fillup the from"
    end

    def message_for_exsit
      "Hi, Fillup the application by accessing the url https://genesis18.typeform.com/to/M7Zo8Z?token=#{@object.token}"
    end
end
