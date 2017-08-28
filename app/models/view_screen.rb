class ViewScreen < ApplicationRecord

  enum screen_for: { job_application: 'Job Application' }

  has_many :screen_tabs, dependent: :destroy
  accepts_nested_attributes_for :screen_tabs, allow_destroy: true, reject_if: :all_blank
  has_many :tab_fields, through: :screentabs

  validates_presence_of :screen_for

  after_initialize :assign_screen_for

  private
    def assign_screen_for
      self.screen_for = 'job_application' if self.new_record?
    end
end
