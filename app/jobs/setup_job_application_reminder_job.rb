class SetupJobApplicationReminderJob < ApplicationJob
  queue_as :urgent

  def perform(*args)
    job_application = JobApplication.find(args[0])
    reminder_message = ReminderMessage.find(args[1])

    if job_application && reminder_message
      merchant = job_application.applicant.merchant
      locale = merchant && merchant.user.present? ? merchant.user.locale : 'en'
      message = Globalize.with_locale(locale.to_sym) { reminder_message.message }

      job_application.update_attributes(last_reminder_at: Time.now)
      TwilioResponse.new(message, job_application.applicant.mobile_no).send_response if job_application.full_response.blank?
    end
  end
end
