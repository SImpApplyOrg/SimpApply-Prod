class JobApplication < ApplicationRecord

  validates_presence_of :merchant_id

  belongs_to :applicant
  belongs_to :merchant
end
