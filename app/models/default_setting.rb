class DefaultSetting < ApplicationRecord
  DEFAULT_MAX_APPLICATION_LIMIT = 5

  validates_presence_of :default_max_application_limit_for_trail_merchant

  before_create :default_applicant_size

  private
    def default_applicant_size
      self.default_max_application_limit_for_trail_merchant = DEFAULT_MAX_APPLICATION_LIMIT
    end
end
