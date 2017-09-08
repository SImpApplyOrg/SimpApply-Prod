class Merchant < ApplicationRecord

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :uuid, length: { minimum: 5, maximum: 10 }, if: '!uuid.blank?'
  validates :uuid, format: { with: /\A[a-zA-Z0-9]+\Z/i, message: "must be alphanumeric" }, if: '!uuid.blank?'

  validates :email, format: { with: VALID_EMAIL_REGEX }, if: '!email.blank?'

  validates :uuid, presence: true, unless: -> (user){user.email.present?}
  validates :email, presence: true, unless: -> (user){user.uuid.present?}

  before_create :generate_token, :assign_reminder_date

  belongs_to :user, optional: true
  has_many :job_applications
  has_many :applicants, through: :job_applications

  def self.get_merchant_and_message_type(options)
    merchant_code = options[:Body].strip.downcase

    return [nil, 'blank'] if merchant_code.blank?

    return check_and_get_merchant(options, (merchant_code.include? '@'))
  end

  def self.send_reminder_messages
    Merchant.where("user_id IS NULL").each do |merchant|
      ReminderMessage.merchant.each do |reminder_message|
        reminder_date = merchant.get_reminder_date(reminder_message)

        SetupMerchantReminderJob.perform_now(merchant.id, reminder_message.id) if reminder_date.to_date == Date.today
      end
    end
  end

  def get_reminder_date(reminder_message)
    (reminder_message.since_signup_date? ? self.created_at : self.last_reminder_at) + reminder_message.remind_after.days
  end

  def send_mail(message_type)
    MerchantMailer.welcome(self.id).deliver if message_type == 'email_new'
    MerchantMailer.get_application(self.id).deliver
  end

  private
    def generate_token
      self.token = SecureRandom.base58(24)
    end

    def assign_reminder_date
      self.last_reminder_at = Time.now
    end

    def self.check_and_get_merchant(options, merchant_with_email=false)
      merchant_code = options[:Body].strip.downcase

      where_clause = "#{merchant_with_email ? 'email' : 'uuid'} = '#{merchant_code}'"

      message_type_prefix = merchant_with_email ? 'email_' : ''

      merchant = where(where_clause).first
      return [merchant, "#{message_type_prefix}exist"] unless merchant.blank?

      hash_options = merchant_with_email ? { email: merchant_code } : { uuid: merchant_code, mobile_no: options[:From] }
      merchant = create(hash_options)
      return [merchant, "#{message_type_prefix}error"] if merchant.errors.any?

      return [merchant, "#{message_type_prefix}new"]
    end
end
