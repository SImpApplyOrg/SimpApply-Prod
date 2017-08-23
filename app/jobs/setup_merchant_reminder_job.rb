class SetupMerchantReminderJob < ApplicationJob
  queue_as :urgent

  def perform(*args)
    merchant = Merchant.find(args[0])
    reminder_message = ReminderMessage.find(args[1])

    if merchant && reminder_message
      merchant.update_attributes(last_reminder_at: Time.now)

      TwilioResponse.new(reminder_message.message, merchant.mobile_no).send_response if merchant.user_id.blank?
    end
  end
end
