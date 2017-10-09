class MessageTag < ApplicationRecord
  belongs_to :job_application_question, optional: true

  validates :tag_name, presence: true
  validates :tag_name, format: { with: /\A[a-z_]+\Z/, message: "only allow alphabates and underscore" }, if: '!tag_name.blank?'

  validate :check_tag_value_or_type_from_question, if: "is_editable?"

  def check_tag_value_or_type_from_question
    if tag_value.blank? && job_application_question_id.blank?
      errors.add(:base, 'At-least one tag_value or job_application_question should be present.')
    end
  end

  def self.get_tag_value(tag_name, applicant)
    message_tag = MessageTag.where(tag_name: tag_name).first

    message_tag.blank? ? "" : message_tag.get_tag_value(applicant)
  end

  def get_tag_value(applicant)
    if job_application_question && applicant
      applicant.get_message_tag_value(job_application_question.field_id.to_s)
    else
      self.tag_value || ''
    end
  end
end
