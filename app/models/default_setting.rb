class DefaultSetting < ApplicationRecord
  DEFAULT_APPLICANT_SIZE = 5

  after_initialize :default_applicant_size

  private
    def default_applicant_size
      self.max_applicant_size = DEFAULT_APPLICANT_SIZE
    end
end
