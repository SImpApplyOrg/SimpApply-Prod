class Applicant < ApplicationRecord

  validates_presence_of :merchant_id

  belongs_to :merchant
  has_many :job_applications
end
