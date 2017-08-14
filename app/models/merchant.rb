class Merchant < ApplicationRecord

  validates_presence_of :uuid
  validates :uuid, length: { minimum: 5, maximum: 10 }, if: '!uuid.blank?'
  validates :uuid, format: { with: /[A-Za-z0-9]/, message: "must be alphanumeric" }, if: '!uuid.blank?'

  before_create :generate_token

  def self.get_merchant(options)

    return [nil, 'blank'] if options[:Body].blank?

    merchant = where(uuid: options[:Body]).first
    return [merchant, 'exist'] unless merchant.blank?

    merchant = create(uuid: options[:Body], mobile_no: options[:From])
    return [merchant, 'error'] if merchant.errors.any?

    [merchant, 'new']
  end

  private
    def generate_token
      self.token = SecureRandom.base58(24)
    end
end
