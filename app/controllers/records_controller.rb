class RecordsController < ApplicationController
  before_action :set_project
  before_action :set_record, only: [:show, :update, :destroy]

  # GET /records/1
  def show
  end

  # GET /records/new
  def new
    @record = @project.records.new
  end

  # POST /records
  def create
    @record = @project.records.new(record_params)
    @record.initial_time = Time.current.hour.hour.value + Time.current.min.minutes.value if params[:open]
    if @record.save
      redirect_to @project, notice: t('notifications.create', model: Record.model_name.human)
    else
      render :new
    end
  end

  # PATCH/PUT /records/1
  def update
    if params[:close]
      @record.final_time = Time.current.hour.hour.value + Time.current.min.minutes.value
      if @record.save
        redirect_to @project, notice: 'Registro fechado com sucesso.'
      else
        redirect_to @project, alert: 'Não foi possível fechar o registro.'
      end
    else
      if @record.update_attributes(record_params)
        redirect_to @project, notice: t('notifications.update', model: Record.model_name.human)
      else
        render :show
      end
    end
  end

  # DELETE /records/1
  def destroy
    @record.destroy
    redirect_to @project, notice: t('notifications.destroy', model: Record.model_name.human)
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
      model_name = :record
      model_name = :amount_record if params[:amount_record].present?
      model_name = :time_record if params[:time_record].present?
      params.require(model_name).permit(:type, :date, :description,
        :initial_hour, :initial_minute, :final_hour, :final_minute,
        :hours, :minutes)
    end
end
