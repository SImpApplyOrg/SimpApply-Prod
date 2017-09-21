class JobApplicationQuestion < ApplicationRecord
  has_many :tab_fields, dependent: :destroy

  def question_text
    question_title.blank? ? question : question_title
  end
end
