class TabField < ApplicationRecord
  belongs_to :screen_tab
  belongs_to :job_application_question
  validates :job_application_question_id, presence: true
end
