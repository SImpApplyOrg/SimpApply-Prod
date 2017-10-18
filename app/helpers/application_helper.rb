module ApplicationHelper
  def check_role
    receiver = UserInvitation.by_receiver(current_user.id).first
    return true if receiver.blank?   
    if (receiver.role == "Manager" || receiver.role == "Reviewer"  )
      false 
    end
  end
end
