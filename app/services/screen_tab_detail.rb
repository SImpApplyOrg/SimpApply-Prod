class ScreenTabDetail

  def initialize(view_screen, applicant)
    @view_screen = view_screen
    @applicant = applicant
  end

  def get_answers(screen_tab=nil)
    screen_tab ||= @view_screen.screen_tabs.active.first
    tab_questions = get_tab_field_questions(screen_tab)

    build_question_answer_hash(tab_questions)
  end

  private

    def build_question_answer_hash(tab_questions)
      answers = {}
      if @applicant.have_details?
        question_answers = JSON.parse(@applicant.question_answers)

        tab_questions.each_with_index do |question, index|
          question_answers.each do |question_answer|
            if question_answer["question_id"] == question.field_id.to_s
              answers[index] = question_answer
              break
            end
          end
        end
      end
      answers
    end

    def get_tab_field_questions(screen_tab)
      screen_tab ? screen_tab.job_application_questions : []
    end

end
