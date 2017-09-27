class ParseTypeFormResponse

  def initialize(questions, answers)
    @questions_arr = questions ||= "[]"
    @answers_arr = answers ||= "[]"
  end

  def get_question_answers
    question_answers = []
    JSON.parse(@questions_arr).each do |question_hash|
      question_id = question_hash["id"]

      answer_hash = get_answer_hash(question_id)

      question_answers << { question_id: question_id, question: format_question(question_hash["title"]), answer: get_correct_answer(answer_hash) }
    end
    question_answers
  end

  private

    def get_answer_hash(question_id)
      answer = {}
      JSON.parse(@answers_arr).each do |answer_hash|
        if answer_hash["field"]["id"] == question_id
          answer = answer_hash
          break
        end
      end
      answer
    end

    def get_correct_answer(answer_hash)
      case answer_hash["type"]
      when "choices"
        answer_hash[answer_hash["type"]]["labels"]
      when 'choice'
        answer_hash[answer_hash["type"]]["label"]
      else
        answer_hash[answer_hash["type"]]
      end
    end

    def format_question(question_title)
      sub_strings = question_title.scan( /{{([^}}]*)}}/).flatten

      if sub_strings
        sub_strings.each do |sub_string|
          question_id = sub_string.strip.split('_').last
          answer_hash = get_answer_hash(question_id)

          answer = get_correct_answer(answer_hash)

          question_title = question_title.gsub("{{answer_#{question_id}}}", answer)
        end
      end
      question_title
    end
end
