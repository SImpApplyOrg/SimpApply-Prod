class Admins::JobApplicationQuestionsController < Admins::ApplicationController

  def index
    @job_application_questions = JobApplicationQuestion.all.order('field_id').page(params[:page])
  end

  def update
    @job_application_question = JobApplicationQuestion.find(params[:id])
    @job_application_question.update_attributes(job_application_question_params)
  end

  def fetch_questions
    typeform = TYPE_FORM_CLIENT.typeform(ENV['typeform_uid'])
    questions = typeform.questions
    all_questions = JSON.parse(questions.to_json(:only=> ["field_id", "question"]))

    typeform_questions = all_questions.map{|ques| JobApplicationQuestion.create(ques) unless JobApplicationQuestion.pluck(:question).include? ques["question"] }
    redirect_to admins_job_application_questions_path, notice: 'JobApplicationQuestion fetched successfully'
  end

  private
    def job_application_question_params
      params.require(:job_application_question).permit(:question_title)
    end
end

