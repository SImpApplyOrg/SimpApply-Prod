class UserInvitation < ApplicationRecord
  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"

  enum role: { manager: 'Manager', reviewer: 'Reviewer' }
  enum status: { pending: 'pending', accept: 'accept', reject: 'reject' }

  validates :sender_id, :receiver_id, :token, presence: true

  after_create :send_invitation
  after_initialize :generate_user_invite_token

  private
    def send_invitation
      # UserInvitationMailer.send_invitation(self).deliver
      message_response = MessageResponse.new("invite_#{role}", self.sender.merchant, nil, self.token)
      TwilioResponse.new(message_response.get_message, self.receiver.mobile_no).send_response
    end

    def generate_user_invite_token
      self.token = SecureRandom.urlsafe_base64 if new_record?
    end
end
