class ScreenTabDetail

  def initialize(view_screen, applicant, merchant)
    @view_screen = view_screen
    @applicant = applicant
    @merchant = merchant
  end

  def get_details(screen_tab=nil)
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
          if question.field_id.blank?
            no_of_applications = @applicant.job_applications.where(merchant_id: @merchant.id).size
            answers[index] = {"question" => question.question_text, "answer" => no_of_applications }
          else
            not_matched = true
            question_answers.each do |question_answer|
              if question_answer["question_id"] == question.field_id.to_s
                question_answer["question"] = question.question_title if question.question_title.present?
                answers[index] = question_answer
                not_matched = false
                break
              end
            end

            if not_matched
              puts "field_id ================ #{question.field_id}"
              answers[index] = { "question" => question.question_text, "answer" => "" }
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
