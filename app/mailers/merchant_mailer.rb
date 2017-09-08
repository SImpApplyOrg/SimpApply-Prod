class MerchantMailer < ApplicationMailer
  require "mandrill"

  default(
    from: "no-reply@simp-apply.com"
  )

  def welcome(merchant_id)
    find_merchant(merchant_id)

    subject = "Welcome to our awesome app!"
    merge_vars = {
      "EMAIL" => @merchant.email,
      "MESSAGE_BODY" => MessageResponse.new(@merchant.token, 'new').get_message,
    }
    body = mandrill_template(ENV["email_new_template"], merge_vars)

    send_mail(@merchant.email, subject, body)
  end

  def get_application(merchant_id)
    find_merchant(merchant_id)

    subject = "You got a new application"
    merge_vars = {
      "EMAIL" => @merchant.email,
      "MESSAGE_BODY" => MessageResponse.new('', 'new_application').get_message,
    }
    body = mandrill_template(ENV["email_new_template"], merge_vars)

    send_mail(@merchant.email, subject, body)
  end

  private
    def find_merchant(merchant_id)
      @merchant = Merchant.find(merchant_id)
    end

    def send_mail(email, subject, body)
      mail(to: email, subject: subject, body: body, content_type: "text/html")
    end

    def mandrill_template(template_name, attributes)
      mandrill = Mandrill::API.new(ENV["mandrillapp_key"])

      merge_vars = attributes.map do |key, value|
        { name: key, content: value }
      end

      mandrill.templates.render(template_name, [], merge_vars)["html"]
    end
end
