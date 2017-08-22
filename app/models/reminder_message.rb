class ReminderMessage < ApplicationRecord

  translates :message

  enum reminder_fors: { merchant: "merchant", applicant: "applicant" }

  validates_presence_of :reminder_for, :remind_after, :message

  def remind_after_days_text
    "#{remind_after} #{I18n.t('.days', :default => I18n.t('helpers.labels.days'))}"
  end
end
