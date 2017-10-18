class UserInvitation < ApplicationRecord
  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"

  enum role: { manager: 'Manager', reviewer: 'Reviewer' }
  enum status: { pending: 'pending', accept: 'accept', reject: 'reject' }
  
  validates :sender_id, :receiver_id, :token, presence: true

  scope :by_receiver, ->(id){ where(receiver_id:  id) }
end
