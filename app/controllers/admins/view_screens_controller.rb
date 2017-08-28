class Admins::ViewScreensController < Admins::ApplicationController
  before_action :set_view_screen, except: [:index, :new, :create]

  def index
    @view_screens = ViewScreen.all
  end

  def new
    @view_screen = ViewScreen.new
    screen_tab = @view_screen.screen_tabs.build
    @tab_fields = screen_tab.tab_fields.build
    @all_job_app = JobApplicationQuestion.all
    respond_to do |format|
      format.js
      format.html
    end
  end

  def create
    @view_screen = ViewScreen.new(view_screen_params)
    if @view_screen.save
      redirect_to admins_view_screens_path, notice: "Created successfully"
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
    if @view_screen.update_attributes(view_screen_params)
      redirect_to admins_view_screens_path, notice: "Updated successfully"
    else
      flash[:error] = "There was some error in update"
      render :edit
    end
  end

  def destroy
    @view_screen.destroy
    flash[:notice] = "Destroyed successfully"
    redirect_to admins_view_screens_path
  end

  private

    def set_view_screen
      @view_screen = ViewScreen.find(params[:id])
    end

    def view_screen_params
      params.require(:view_screen).permit(:screen_for, screen_tabs_attributes: [:id, :name, :position, :is_active, :_destroy, tab_fields_attributes: [:id, :job_application_question_id, :_destroy]])
    end
end
