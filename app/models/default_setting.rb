class DefaultSetting < ApplicationRecord
  DEFAULT_APPLICANT_SIZE = 5

  validates_presence_of :max_applicant_size

  before_create :default_applicant_size

  private
    def default_applicant_size
      self.max_applicant_size = DEFAULT_APPLICANT_SIZE
    end
end
