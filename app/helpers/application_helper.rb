module ApplicationHelper

  def user_name(user)
    (user.full_name.blank? ? user.email : user.full_name)
  end
end
