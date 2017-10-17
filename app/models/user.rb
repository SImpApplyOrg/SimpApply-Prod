class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessor :token, :temp_invitation_token

  enum roles: { merchant: 'Merchant', manager: 'Manager', reviewer: 'Reviewer' }

  after_initialize :assign_default_values, :assign_default_role
  before_create :assign_default_values
  after_create :assign_user_to_merchant
  after_save :create_user_invitation, :if => :invitation_token?
  after_update :change_user_invite_status, if: "!temp_invitation_token.blank?"

  has_one :merchant
  has_many :applicants, through: :merchant
  has_many :job_applications, through: :merchant

  has_many :user_invitations, foreign_key: "sender_id", dependent: :destroy
  has_many :reverse_user_invitations, foreign_key: "receiver_id", class_name: "UserInvitation", dependent: :destroy

  def active_for_authentication?
    #remember to call the super
    #then put our own check to determine "active" state using
    #our own "is_active" column
    super && self.is_active?
  end

  def full_name
    "#{first_name} #{last_name}".humanize
  end

  def invite_status
    invitation_accepted_at.blank? ? 'Pending' : 'Accepted'
  end

  private
    def assign_user_to_merchant
      if !User.roles.reject{|role| role == 'merchant'}.keys.include?(self.role)
        merchant = Merchant.where(token: self.token).first
        merchant.update_attributes(user_id: self.id, email: self.email, token: nil)
      end
    end

    def create_user_invitation
      if user_inivitation = UserInvitation.create!(sender_id: invited_by_id, receiver_id: id)
        UserInvitationMailer.send_invitation(user_inivitation).deliver
      end
    end

    def generate_user_invite_token
      token = SecureRandom.urlsafe_base64
    end

    def assign_default_values
      if self.new_record? && !User.roles.reject{|role| role == 'merchant'}.keys.include?(self.role)
        merchant = Merchant.where(token: self.token).first

        if merchant
          self.mobile_no = merchant.mobile_no if merchant.mobile_no.present?
          self.email = merchant.email if merchant.email.present?
        end
      end
    end

    def assign_default_role
      self.role ||= "merchant" if self.new_record?
    end

    def change_user_invite_status
      user_invitation = UserInvitation.where(token: temp_invitation_token).first
      user_invitation.accept!
    end
end
