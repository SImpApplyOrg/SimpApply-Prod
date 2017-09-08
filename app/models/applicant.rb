class Applicant < ApplicationRecord

  before_create :assign_reminder_date

  has_many :job_applications
  has_many :merchants, through: :job_applications

  def self.send_reminder_messages
    where("full_response IS NULL").each do |applicant|
      ReminderMessage.applicant.each do |reminder_message|
        reminder_date = applicant.get_reminder_date(reminder_message)

        SetupJobApplicationReminderJob.perform_now(applicant.id, reminder_message.id) if reminder_date.to_date == Date.today
      end
    end
  end

  def get_reminder_date(reminder_message)
    (reminder_message.since_signup_date? ? self.created_at : self.last_reminder_at) + reminder_message.remind_after.days
  end

  def have_details?
    !full_response.blank?
  end

  def generate_token_and_create_job_application(merchant)
    self.token = SecureRandom.base58(24)
    self.save
    create_job_application(merchant)
  end

  def create_job_application(merchant)
    job_applications.create(merchant_id: merchant.id)
  end

  private

    def assign_reminder_date
      self.last_reminder_at = Time.now
    end
end
