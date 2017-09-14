class JobApplicationQuestion < ApplicationRecord

  def question_text
    question_title.blank? ? question : question_title
  end
end
