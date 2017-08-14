class Admins::MerchantsController < Admins::ApplicationController
  before_action :get_merchant, only: [:suspend, :active]
  def index
    @merchants = Merchant.joins(:user)
  end

  def suspend
    @merchant.user.update_attributes(is_active: false)
  end

  def active
    @merchant.user.update_attributes(is_active: true)
  end

  private
    def get_merchant
      @merchant = Merchant.find(params[:merchant_id])
    end
end