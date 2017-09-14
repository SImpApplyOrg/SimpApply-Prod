module ApplicantsHelper

  def get_details(view_screen, applicant, screen_tab=nil)
    ScreenTabDetail.new(view_screen, applicant, current_user.merchant).get_details(screen_tab)
  end
end
