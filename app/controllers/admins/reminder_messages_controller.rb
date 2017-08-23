class Admins::ReminderMessagesController < Admins::ApplicationController
  before_action :set_reminder_message, except: [:index, :new, :create]
  before_action :get_locales, only: [:edit, :update]

  def index
    @reminder_messages = ReminderMessage.all
  end

  def new
    @reminder_message = ReminderMessage.new
  end

  def create
    @reminder_message = ReminderMessage.new(reminder_message_params)
    if @reminder_message.save
      redirect_to admins_reminder_messages_path, notice: "Created successfully"
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
    if @reminder_message.update_attributes(reminder_message_params)
      redirect_to admins_reminder_messages_path, notice: 'Updated successfully'
    else
      flash[:error] = "There was some error in update"
      render :edit
    end
  end

  def destroy
    @reminder_message.destroy
    flash[:notice] = "Destroyed successfully"
    redirect_to admins_reminder_messages_path
  end

  private
    def reminder_message_params
      params.require(:reminder_message).permit(:reminder_for, :remind_after, :message, :locale, :remind_preference)
    end

    def set_reminder_message
      @reminder_message = ReminderMessage.find(params[:id])
    end

    def get_locales
      added_locales = @reminder_message.translations.map(&:locale)
      @locales = params[:lang].blank? ? (I18n.available_locales - added_locales) : [params[:lang]]
    end
end
