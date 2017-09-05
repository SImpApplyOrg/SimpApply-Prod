class TabField < ApplicationRecord
  belongs_to :screen_tab
  belongs_to :job_application_question

  validates_presence_of :job_application_question_id
end
