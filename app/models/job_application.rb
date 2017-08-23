class JobApplication < ApplicationRecord

  before_create :generate_token, :assign_reminder_date

  belongs_to :applicant

  scope :completed_applications, -> { where("full_response IS NOT NULL") }

  def self.send_reminder_messages
    JobApplication.where("full_response IS NULL").each do |job_application|
      ReminderMessage.applicant.each do |reminder_message|
        reminder_date = job_application.get_reminder_date(reminder_message)

        SetupJobApplicationReminderJob.set(wait_until: reminder_date).perform_later(job_application.id, reminder_message.id) if reminder_date.to_date == Date.today
      end
    end
  end

  def get_reminder_date(reminder_message)
    (reminder_message.since_signup_date? ? self.created_at : self.last_reminder_at) + reminder_message.remind_after.days
  end

  private
    def generate_token
      self.token = SecureRandom.base58(24)
    end

    def assign_reminder_date
      self.last_reminder_at = Time.now
    end
end
