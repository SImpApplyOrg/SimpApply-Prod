class JobApplication < ApplicationRecord

  before_create :generate_token

  belongs_to :applicant

  scope :completed_applications, -> { where("full_response IS NOT NULL") }

  private
    def generate_token
      self.token = SecureRandom.base58(24)
    end
end
