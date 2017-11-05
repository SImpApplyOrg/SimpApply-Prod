class MessageResponse

  def initialize(message_type, merchant, applicant, token=nil)
    @message_type = message_type

    @merchant = merchant
    @applicant = applicant
    @token = token
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
    when "applicant_exist"
      "applicant_exist"
    when 'email_error'
      "error_in_email"
    when "error_in_submit_applicant"
      "error_in_submit_applicant"
    when 'invite_manager'
      'invite_manager'
    when 'invite_reviewer'
      'invite_reviewer'
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
      mailer_options = message.scan( /{{([^}}]*)}}/).flatten
      mailer_options.each do |tag|
        message.gsub!("{{#{tag}}}", get_tag_value(tag))
      end
      message
    end

    def get_tag_value(tag)
      case tag
      when 'sign_up_link'
        Rails.application.routes.url_helpers.new_user_registration_url(token: @merchant.token) if @merchant
      when 'type_form_link'
        Rails.application.routes.url_helpers.get_type_form_type_form_web_hooks_url(token: @applicant.token) if @applicant
      when 'job_application_link'
        Rails.application.routes.url_helpers.applicants_url
      when 'invitation_accept_link'
        Rails.application.routes.url_helpers.accept_user_invitation_url(token: @token)
      when 'merchant_first_name'
        @merchant.user.first_name if @merchant.present? && @merchant.user.present?
      when 'organization_name'
        @merchant.user.organization_name if @merchant.present? && @merchant.user.present?
      else
        MessageTag.get_tag_value(tag, @applicant)
      end
    end

    def translated_message(response_message)
      if ['exist', 'new_application', 'view_application'].include? @message_type

        locale = @merchant && @merchant.user.present? ? @merchant.user.locale : 'en'
        Globalize.with_locale(locale.to_sym) { response_message.message }
      else
        response_message.message
      end
    end
end
