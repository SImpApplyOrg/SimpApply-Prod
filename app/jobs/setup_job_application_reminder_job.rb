class SetupJobApplicationReminderJob < ApplicationJob
  queue_as :urgent

  def perform(*args)
    applicant = Applicant.find(args[0])
    reminder_message = ReminderMessage.find(args[1])

    if applicant && reminder_message
      merchant = applicant.merchant
      locale = merchant && merchant.user.present? ? merchant.user.locale : 'en'
      message = Globalize.with_locale(locale.to_sym) { reminder_message.message }

      applicant.update_attributes(last_reminder_at: Time.now)
      TwilioResponse.new(message, applicant.mobile_no).send_response if applicant.full_response.blank?
    end
  end
end
