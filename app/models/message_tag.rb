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
end
