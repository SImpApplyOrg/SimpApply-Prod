module JobApplicationsHelper

  def get_answers(view_screen, job_application)
    ScreenTabDetail.new(view_screen, job_application).get_answers
  end
end
