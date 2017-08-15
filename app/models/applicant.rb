class Applicant < ApplicationRecord

  validates_presence_of :merchant_id

  before_create :generate_token

  belongs_to :merchant
  belongs_to :user

  private
    def generate_token
      self.token = SecureRandom.base58(24)
    end
end
