desc "To send reminder message to Merchant and Applicant"
task :send_reminders => :environment do
  Merchant.send_reminder_messages
  JobApplication.send_reminder_messages
end