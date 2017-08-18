class MessageResponse

  def initialize(token, message_type)
    @token = token
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
    when 'new_application'
      "new_application_form"
    when 'view_application'
      "view_application_form"
    end

    response_message = ResponseMessage.where(message_type: message_type).first

    if response_message.blank?
      raise Exceptions::ResponseMessageNotFoundError
    else
      customize_message(translated_message(response_message))
    end
  end

  private
    def customize_message(message)
      mailer_options = ResponseMessage::MARKUP_VARIABLES
      {
        sign_up_link: Rails.application.routes.url_helpers.new_user_registration_url(token: @token),
        type_form_link: "#{ENV['type_form_url']}#{@token}"
      }.each do |key, value|
        message.gsub!(mailer_options[key], value) if message.include? mailer_options[key]
      end

      message
    end

    def translated_message(response_message)
      if ['exist', 'new_application', 'view_application'].include? @message_type
        merchant = if @message_type == "exist"
          JobApplication.where(token: @token).first.applicant.merchant
        else
          Merchant.where(token: @token).first
        end
        locale = merchant && merchant.user.present? ? merchant.user.locale : 'en'
        Globalize.with_locale(locale.to_sym) { response_message.message }
      else
        response_message.message
      end
    end
end
