class ScreenTabDetail

  def initialize(view_screen, applicant, merchant, screen_tab=nil)
    @view_screen = view_screen
    @applicant = applicant
    @merchant = merchant
    @screen_tabs = @view_screen.screen_tabs.active
    @screen_tab = screen_tab
  end

  def get_details
    tab_questions = get_tab_field_questions(@screen_tab)

    build_question_answer_hash(tab_questions)
  end

  def get_screen_tabs_for_applicant
    _screen_tabs = []
    @screen_tabs.each do |screen_tab|
      @screen_tab = screen_tab
      next if answer_present(get_details) < 1
      _screen_tabs << screen_tab
    end
    _screen_tabs
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
                answers[index] = modify_answer(question_answer, question)
                not_matched = false
                break
              end
            end

            # if not_matched
            #   puts "field_id ================ #{question.field_id}"
            #   answers[index] = { "question" => question.question_text, "answer" => "N/A" }
            # end
          end

        end
      end
      answers
    end

    def modify_answer(question_answer, question)
      case question.field_type
      when 'list'
        question_answer["answer"] = question_answer["answer"].join(", ") if question_answer["answer"].is_a? Array
      else
        question_answer
      end
      question_answer
    end

    def get_tab_field_questions(screen_tab)
      screen_tab ? screen_tab.job_application_questions.order("position") : []
    end

    def answer_present(applicant_details)
      count = 0
      applicant_details.each  do |index, answer|
        if answer["answer"].present?
          count += 1
        end
      end
      count
    end

end
