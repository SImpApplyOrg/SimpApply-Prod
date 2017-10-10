class ScreenTab < ApplicationRecord
  has_many :tab_fields, dependent: :destroy
  accepts_nested_attributes_for :tab_fields, :allow_destroy => true
  belongs_to :view_screen, required: false

  has_many :job_application_questions, through: :tab_fields, source: :job_application_question

  validates_presence_of :name, :position
  validates_uniqueness_of :position, scope: :view_screen_id

  scope :active, -> { where(is_active: true) }

  before_save :check_and_change_position

  private
    def check_and_change_position
      max_position = view_screen.screen_tabs.maximum("position")
      self.position ||= max_position.blank? ? 1 : max_position + 1
    end
end
