class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessor :token

  after_initialize :assign_default_values
  before_create :assign_default_values
  after_create :assign_user_to_merchant

  has_one :merchant
  has_many :applicants, through: :merchant
  has_many :job_applications, through: :merchant

  def active_for_authentication?
    #remember to call the super
    #then put our own check to determine "active" state using
    #our own "is_active" column
    super && self.is_active?
  end

  private
    def assign_user_to_merchant
      merchant = Merchant.where(token: self.token).first
      merchant.update_attributes(user_id: self.id, email: self.email, token: nil)
    end

    def assign_default_values
      if self.new_record?
        merchant = Merchant.where(token: self.token).first

        if merchant
          self.mobile_no = merchant.mobile_no if merchant.mobile_no.present?
          self.email = merchant.email if merchant.email.present?
        end
      end
    end

end
