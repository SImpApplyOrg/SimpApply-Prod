class ViewScreen < ApplicationRecord

  enum screen_for: { job_application: 'Job Application' }

  has_many :screen_tabs, -> { order('position ASC') }, dependent: :destroy
  accepts_nested_attributes_for :screen_tabs, allow_destroy: true
  has_many :tab_fields, through: :screen_tabs

  validates_presence_of :screen_for
  # validates_uniqueness_of :screen_for, if: 'screen_for.present?'
  validate :check_screen_tabs_position

  after_initialize :assign_screen_for

  scope :active_screens, -> { where(is_active: true) }

  private
    def assign_screen_for
      self.screen_for = 'job_application' if self.new_record?
    end

    def check_screen_tabs_position
      positions = screen_tabs.pluck(:position)
      errors.add(:base, "Must have at-least one screen tab.") if screen_tabs.blank?
      screen_tabs.each do |screen_tab|
        if screen_tab.new_record?
          if positions.include?(screen_tab.position)
            errors.add(:'screen_tabs.position', 'has already been taken')
          else
            positions << screen_tab.position
          end

          errors.add(:'screen_tabs.job_application_question', 'select at-least one') if screen_tab.tab_fields.blank?
        end
      end
    end
end
