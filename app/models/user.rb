class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessor :token, :temp_invitation_token, :user_role, :is_merchant, :country_code, :invite_for_id

  after_initialize :assign_default_values, if: "user_role.blank?"
  before_create :assign_default_values, if: "user_role.blank?"
  after_create :assign_user_to_merchant, if: "user_role.blank?"
  after_save :create_user_invitation, :if => :invitation_token?
  after_update :change_user_invite_status, if: "!temp_invitation_token.blank?"

  before_create :full_mobile_no

  validates_presence_of :organization_name, if: "is_merchant == 'true'"
  validates_format_of :organization_name, with: /\A[a-zA-Z]+(?: [a-zA-Z]+)?\z/, if: "organization_name.present?"
  validates_plausible_phone :mobile_no, country_number: :country_code, presence: true, with: /\A\+\d+/
  validate :validate_mobile_number

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

  def merchant?
    merchant.present?
  end

  def manager?(current_organization_user)
    reverse_user_invitations.where(sender_id: current_organization_user.id).first.try(:manager?)
  end

  def reviewer?(current_organization_user)
    reverse_user_invitations.where(sender_id: current_organization_user.id).first.try(:reviewer?)
  end

  def temp_email?
    email.include?('xyz.com')
  end

  def full_mobile_no
    self.mobile_no = "#{self.country_code}#{self.mobile_no}"
  end

  private
    def assign_user_to_merchant
      if self.user_role.blank?
        merchant = Merchant.where(token: self.token).first
        merchant.update_attributes(user_id: self.id, email: self.email, token: nil)
      end
    end

    def assign_default_values
      if self.new_record? && self.user_role.blank?
        merchant = Merchant.where(token: self.token).first

        if merchant
          self.mobile_no = merchant.mobile_no if merchant.mobile_no.present?
          self.email = merchant.email if merchant.email.present?
        end
      end
    end

    def create_user_invitation
      user_inivitation = UserInvitation.where(sender_id: invite_for_id, receiver_id: id).first
      unless user_inivitation
        UserInvitation.create(sender_id: invite_for_id, receiver_id: id, role: user_role)
      end
    end

    def change_user_invite_status
      user_invitation = UserInvitation.where(token: temp_invitation_token).first
      user_invitation.accept!
    end

    def validate_mobile_number
      errors.add(:mobile_no, "is not a valid number.") if self.mobile_no.present? && !Phonie::Phone.parse(self.mobile_no)
    end
end
