class RecordsController < ApplicationController
  before_action :set_project
  before_action :set_record, only: [:show, :edit, :update, :destroy]

  # GET /records/1
  def show
  end

  # GET /records/new
  def new
    @record = @project.records.new
  end

  # GET /records/1/edit
  def edit
  end

  # POST /records
  def create
    @record = @project.records.new(record_params)

    if @record.save
      redirect_to @record, notice: t('notifications.create', model: Record.model_name.human)
    else
      render :new
    end
  end

  # PATCH/PUT /records/1
  def update
      if @record.update(record_params)
        redirect_to @record, notice: t('notifications.update', model: Update.model_name.human)
      else
        render :edit
      end
  end

  # DELETE /records/1
  def destroy
    @record.destroy
    respond_to do |format|
      redirect_to records_url, notice: t('notifications.destroy', model: Record.model_name.human)
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.friendly.find(params[:project_id])
    end

    def set_record
      @record = @project.records.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def record_params
      params.require(:record).permit(:type, :date, :description, :initial_hour, :initial_minute, :final_hour, :final_minute, :hours, :minutes, :project_id)
    end
end
