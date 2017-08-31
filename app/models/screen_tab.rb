class ScreenTab < ApplicationRecord
  has_many :tab_fields, dependent: :destroy
  accepts_nested_attributes_for :tab_fields, :allow_destroy => true
  belongs_to :view_screen, required: false

  has_many :job_application_questions, through: :tab_fields, source: :job_application_question

  validates_presence_of :name, :position
  validates_uniqueness_of :position, scope: :view_screen

  scope :active, -> { where(is_active: true) }

end
