module UsersHelper
  def has_token?
    params[:token].present?
  end
end
