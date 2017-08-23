class ReminderMessage < ApplicationRecord

  translates :message

  enum reminder_for: { merchant: "Merchant", applicant: "Applicant" }
  enum remind_preference: { since_signup_date: 'Since signup date', since_last_reminder: 'Since last reminder' }

  after_initialize :default_remind_preference

  validates_presence_of :reminder_for, :remind_after, :message, :remind_preference

  def remind_after_days_text
    "#{remind_after} #{I18n.t('.days', :default => I18n.t('helpers.labels.days'))}"
  end

  private
    def default_remind_preference
      self.remind_preference ||= 'since_signup_date' if self.new_record?
    end
end
