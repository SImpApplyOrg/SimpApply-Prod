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

    question_field_ids = JobApplicationQuestion.type_form_questions.pluck(:field_id)
    type_form_question_field_ids = []
    all_questions.map{ |q| type_form_question_field_ids << q["field_id"] }

    deletable_field_ids = question_field_ids - type_form_question_field_ids
    JobApplicationQuestion.where("field_id in (?)", deletable_field_ids).destroy_all

    all_questions.map do |ques|
      question = JobApplicationQuestion.where(field_id: ques["field_id"]).first
      if question
        question.update_attributes(ques)
      else
        JobApplicationQuestion.create(ques)
      end
    end

    redirect_to admins_job_application_questions_path, notice: 'JobApplicationQuestion fetched successfully'
  end

  private
    def job_application_question_params
      params.require(:job_application_question).permit(:question_title)
    end
end

