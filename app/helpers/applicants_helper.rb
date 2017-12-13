module ApplicantsHelper

  def get_details(view_screen, applicant, screen_tab)
    ScreenTabDetail.new(view_screen, applicant, current_user.merchant, screen_tab).get_details
  end

  def get_screen_tabs_for_applicant(view_screen, applicant)
    ScreenTabDetail.new(view_screen, applicant, current_user.merchant).get_screen_tabs_for_applicant
  end
end
