class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessor :token

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

  def assign_user_to_merchant
    merchant = Merchant.where(token: self.token).first
    merchant.update_attributes(user_id: self.id)
  end

end
