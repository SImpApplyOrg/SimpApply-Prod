class TabField < ApplicationRecord
  belongs_to :screen_tab
  belongs_to :job_application_question

  validates_presence_of :job_application_question_id
  # validates_uniqueness_of :position, scope: :screen_tab_id  (getting an error for positon unigness)

  before_save :check_and_change_position

  private
    def check_and_change_position
      max_position = screen_tab.tab_fields.maximum("position")
      self.position ||= max_position.blank? ? 1 : max_position + 1
    end
end
