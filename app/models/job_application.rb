class JobApplication < ApplicationRecord

  before_create :generate_token

  belongs_to :applicant

  # serialize :full_response, Hash
  # serialize :questions, Hash
  # serialize :answers, Hash

  private
    def generate_token
      self.token = SecureRandom.base58(24)
    end
end
