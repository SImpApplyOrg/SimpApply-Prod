class Admins::ApplicantsController < Admins::ApplicationController
  before_action :get_applicant, only: [:edit, :update]

  def index
    @applicants = Applicant.all
  end

  def edit
  end

  def update
    @applicant.update_attribute(:question_answers, question_answers_hash.to_json.to_s)
    redirect_to edit_admins_applicant_path(@applicant)
  end

  private
    def get_applicant
      @applicant = Applicant.find(params[:id])
    end

    def answer_params
      params.require(:applicant).permit!
    end

    def question_answers_hash
      question_answers = JSON.parse(@applicant.question_answers)
      question_answers.map do |question_answer|
        question_answer.merge!(answer_params[question_answer['question_id'].to_sym])
      end
    end

end
