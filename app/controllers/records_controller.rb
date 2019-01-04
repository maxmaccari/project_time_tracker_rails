# frozen_string_literal: true

class RecordsController < ApplicationController
  before_action :set_project
  before_action :set_record, only: %i[show update destroy]

  # GET /records/1
  def show; end

  # GET /records/new
  def new
    @record = @project.records.new(date: Date.current)
  end

  # POST /records
  def create
    @record = @project.records.new(record_params)

    @record.initial_time = current_time if params[:open]
    if @record.save
      redirect_to @project, notice:
        t('notifications.create', model: Record.model_name.human)
    else
      render :new
    end
  end

  # PATCH/PUT /records/1
  def update
    if params[:close]
      close_record
    elsif @record.update_attributes(record_params)
      redirect_to @project, notice:
        t('notifications.update', model: Record.model_name.human)
    else
      render :show
    end
  end

  # DELETE /records/1
  def destroy
    @record.destroy

    redirect_to @project, notice:
      t('notifications.destroy', model: Record.model_name.human)
  end

  private

  def current_time
    Time.current.hour.hour.value + Time.current.min.minutes.value
  end

  def close_record
    @record.final_time = current_time

    if @record.save
      redirect_to @project, notice: 'Registro fechado com sucesso.'
    else
      redirect_to @project, alert: 'Não foi possível fechar o registro.'
    end
  end

  def set_project
    @project = Project.friendly.find(params[:project_id])
  end

  def set_record
    @record = @project.records.find(params[:id])
  end

  def record_params
    model_name = :record
    model_name = :amount_record if params[:amount_record].present?
    model_name = :time_record if params[:time_record].present?
    params.require(model_name).permit(:type, :date, :description,
                                      :initial_hour, :initial_minute,
                                      :final_hour, :final_minute,
                                      :hours, :minutes)
  end
end
