module ApplicationHelper

  def user_name(user)
    (user.full_name.blank? ? user.email : user.full_name)
  end

  def can_manage_account?
    current_user.merchant? || (current_organization_user.present? && (current_user.manager?(current_organization_user)))
  end

  def zone_time(time)
    phone = Phonelib.parse(current_user.mobile_no)
    time.in_time_zone(phone.timezone).strftime('%a, %e %b %Y %H:%M:%S %Z')
  end
end
