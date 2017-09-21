class Admins::ResponseMessagesController < Admins::ApplicationController
  before_action :set_response_message, except: [:index, :new, :create]
  before_action :get_locales, only: [:edit, :update]
  before_action :get_message_tags, except: [:index, :show, :destroy]

  def index
    @response_messages = ResponseMessage.all
  end

  def new
    @response_message = ResponseMessage.new
  end

  def create
    @response_message = ResponseMessage.new(response_message_params)

    if @response_message.save
      redirect_to admins_response_messages_path, notice: "Created successfully"
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
    if @response_message.update_attributes(response_message_params)
      redirect_to admins_response_messages_path, notice: 'Updated successfully'
    else
      flash[:error] = "There was some error in update"
      render :edit
    end
  end

  def destroy
    @response_message.destroy
    flash[:notice] = "Destroyed successfully"
    redirect_to admins_response_messages_path
  end

  private

    def set_response_message
      @response_message = ResponseMessage.find(params[:id])
    end

    def response_message_params
      params.require(:response_message).permit(:message_type, :message, :locale)
    end

    def get_locales
      added_locales = @response_message.translations.map(&:locale)
      @locales = params[:lang].blank? ? (I18n.available_locales - added_locales) : [params[:lang]]
    end

    def get_message_tags
      @message_tags = MessageTag.all
    end
end
