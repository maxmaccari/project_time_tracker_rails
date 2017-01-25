class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  # GET /projects
  def index
    @projects = Project.root.active unless params[:inactives]
    @projects = Project.root if params[:inactives]
  end

  # GET /projects/1
  def show
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  def create
    @project = Project.new(project_params)

    if @project.save
      redirect_to @project, notice: t('notifications.create', model: Project.model_name.human)
    else
      render :new
    end
  end

  # PATCH/PUT /projects/1
  def update
      if @project.update(project_params)
        redirect_to @project, notice: t('notifications.update', model: Project.model_name.human)
      else
        render :edit
      end
  end

  # DELETE /projects/1
  def destroy
    @project.destroy
      redirect_to projects_url, notice: t('notifications.destroy', model: Project.model_name.human)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.friendly.includes(:subprojects).includes(:records).find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:title, :description, :parent_id,
        :initial_date, :final_date, :active, :estimated_time, :time_value,
        :project_value, :slug)
    end
end
