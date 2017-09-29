class JobApplicationQuestion < ApplicationRecord
  has_many :tab_fields, dependent: :destroy

  PDF_MAPPING = ['1', '2', '3', '4', '5', '6', '7', '8', '22', '23', '18A', '18B', '18C', '18D', '18E', '18F', '18G', '18I', '19B', '19D', '19E', '19F', '20B', '20D', '20E', '20F', '21A', '21B', '21C', '24']

  scope :type_form_questions, -> { where("field_id IS NOT NULL") }
  scope :custom_questions, -> { where("field_id IS NULL") }

  def question_text
    question_title.blank? ? question : question_title
  end
end
