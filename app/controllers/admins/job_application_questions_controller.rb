class Admins::JobApplicationQuestionsController < Admins::ApplicationController

  def index
    @Job_application_questions = JobApplicationQuestion.all
  end

  def fetch_questions
    typeform = TYPE_FORM_CLIENT.typeform(ENV['typeform_uid'])
    questions = typeform.questions
    @all_questions = JSON.parse(questions.to_json(:only=> ["field_id", "question"]))
    @typeform_questions = @all_questions.map{|ques| JobApplicationQuestion.create(ques) unless JobApplicationQuestion.pluck(:question).include? ques["question"] }
    redirect_to admins_job_application_questions_path, notice: 'JobApplicationQuestion fetched successfully'
  end
end

