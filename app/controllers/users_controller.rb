class UsersController < ApplicationController

  def check_mobile_no
    success = Phonie::Phone.parse(params[:user][:mobile_no])
    render json: { valid: !!success }
  end

  def send_verification_code
    verification_code = 5.times.map { (0..9).to_a.sample }.join
    session[:verification_code] = verification_code
    message_response = MessageResponse.new("verification_code", nil, nil, verification_code)
    TwilioResponse.new(message_response.get_message, params[:user][:mobile_no]).send_response
    logger.info session[:verification_code]
    render json: { valid: true }
  end

  def check_verfication_code
    valid = session[:verification_code] == params[:mobile_code]
    # TODO: Remove puts after completing the feature successfully
    puts session[:verification_code]
    render json: { valid: valid }
  end

  def check_merchant_code
    valid = Merchant.where(uuid: params[:user][:merchant_code]).any?
    render json: { valid: !valid }
  end

  def check_email
    valid = User.where(email: params[:user][:email]).any?
    render json: { valid: !valid }
  end

  def invitations
    @invitations = current_user.reverse_user_invitations.pending if current_user
  end

end
