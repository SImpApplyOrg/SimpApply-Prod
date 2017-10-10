class Admins::JobApplicationQuestionsController < Admins::ApplicationController

  def index
    job_application_questions = JobApplicationQuestion.order_by_no
    @job_application_questions = Kaminari.paginate_array(job_application_questions).page(params[:page])
  end

  def update
    @field_type = params[:field_type]
    @job_application_question = JobApplicationQuestion.find(params[:id])
    @job_application_question.update_attributes(job_application_question_params)
  end

  def fetch_questions
    typeform = TYPE_FORM_CLIENT.typeform(ENV['typeform_uid'])
    questions = typeform.questions
    all_questions = JSON.parse(questions.to_json(:only=> ["id", "field_id", "question"]))

    all_questions.map do |question|
      field_type = question.delete("id")
      question.merge!({ "field_type" => field_type.split('_').first })
    end

    question_field_ids = JobApplicationQuestion.type_form_questions.pluck(:field_id)
    type_form_question_field_ids = []
    all_questions.map{ |q| type_form_question_field_ids << q["field_id"] }

    deletable_field_ids = question_field_ids - type_form_question_field_ids
    JobApplicationQuestion.where("field_id in (?)", deletable_field_ids).destroy_all

    all_questions.map do |ques|
      question = JobApplicationQuestion.where(field_id: ques["field_id"]).first
      if question
        unless question.update_attributes(ques)
          logger.debug question.errors.full_messages
        end
      else
        JobApplicationQuestion.create(ques)
      end
    end

    redirect_to admins_job_application_questions_path, notice: 'JobApplicationQuestion fetched successfully'
  end

  def destroy_all
    JobApplicationQuestion.destroy_all
    redirect_to admins_job_application_questions_path, notice: 'Destroyed successfully'
  end

  private
    def job_application_question_params
      params.require(:job_application_question).permit(:question_title, :type_form_question_no)
    end
end

