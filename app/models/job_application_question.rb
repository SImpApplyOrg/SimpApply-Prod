class JobApplicationQuestion < ApplicationRecord
  has_many :tab_fields, dependent: :destroy

  scope :type_form_questions, -> { where("field_id IS NOT NULL") }
  scope :custom_questions, -> { where("field_id IS NULL") }

  def question_text
    question_title.blank? ? question : question_title
  end
end
