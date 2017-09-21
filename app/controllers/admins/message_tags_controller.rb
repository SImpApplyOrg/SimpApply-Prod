class Admins::MessageTagsController < Admins::ApplicationController
  before_action :set_message_tag, except: [:index, :new, :create]
  before_action :check_editable, only: [:edit, :update]
  before_action :get_type_form_questions, except: [:index, :show, :destroy]

  def index
    @message_tags = MessageTag.all
  end

  def new
    @message_tag = MessageTag.new
  end

  def create
    @message_tag = MessageTag.new(message_tag_params)

    if @message_tag.save
      redirect_to admins_message_tags_path, notice: "Created successfully"
    else
      flash[:error] = "There was some errors in saving"
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @message_tag.update_attributes(message_tag_params)
      redirect_to admins_message_tags_path, notice: 'Updated successfully'
    else
      flash[:error] = "There was some error in update"
      render :edit
    end
  end

  def destroy
    if @message_tag.is_editable?
      @message_tag.destroy
      flash[:notice] = "Destroyed successfully"
    else
      flash[:error] = "Can not a destroy non editable tag"
    end
    redirect_to admins_message_tags_path
  end

  private
    def message_tag_params
      params.require(:message_tag).permit(:tag_name, :tag_value, :job_application_question_id)
    end

    def get_type_form_questions
      @type_form_questions = JobApplicationQuestion.type_form_questions
    end

    def check_editable
      if !@message_tag.is_editable?
        flash[:error] = 'Can not edit a non editable tag.'
        redirect_to admins_message_tags_path
      end
    end

    def set_message_tag
      @message_tag = MessageTag.find(params[:id])
    end
end
