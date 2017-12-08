module ApplicationHelper

  def user_name(user)
    (user.full_name.blank? ? user.email : user.full_name)
  end

  def can_manage_account?
    current_user.merchant? || (current_organization_user.present? && (current_user.manager?(current_organization_user) || current_user.reviewer?(current_organization_user)))
  end
end
