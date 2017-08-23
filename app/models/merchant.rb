class Merchant < ApplicationRecord

  validates_presence_of :uuid
  validates :uuid, length: { minimum: 5, maximum: 10 }, if: '!uuid.blank?'
  validates :uuid, format: { with: /[A-Za-z0-9]/, message: "must be alphanumeric" }, if: '!uuid.blank?'

  before_create :generate_token, :assign_reminder_date

  belongs_to :user, optional: true
  has_many :applicants
  has_many :job_applications, through: :applicants

  def self.get_merchant(options)

    return [nil, 'blank'] if options[:Body].blank?

    merchant = where(uuid: options[:Body]).first
    return [merchant, 'exist'] unless merchant.blank?

    merchant = create(uuid: options[:Body], mobile_no: options[:From])
    return [merchant, 'error'] if merchant.errors.any?

    [merchant, 'new']
  end

  def self.send_reminder_messages
    Merchant.where("user_id IS NULL").each do |merchant|
      ReminderMessage.merchant.each do |reminder_message|
        reminder_date = merchant.get_reminder_date(reminder_message)

        SetupMerchantReminderJob.set(wait_until: reminder_date).perform_later(merchant.id, reminder_message.id) if reminder_date.to_date == Date.today
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
