module JobApplicationsHelper

  def get_answers(view_screen, job_application, screen_tab=nil)
    ScreenTabDetail.new(view_screen, job_application.applicant).get_answers(screen_tab)
  end
end
