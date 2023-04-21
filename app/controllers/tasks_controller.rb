class TasksController < ApplicationController
  before_action :require_login
  before_action :correct_user, only: [:show, :edit, :update, :destroy]
  before_action :set_labels 

  def set_labels
    @labels = Label.all 
  end

  def show
    @task = current_user.tasks.find(params[:id])
    unless @task
      flash[:alert] = '本人以外アクセスできません'
      redirect_to tasks_path
    end
  end

  def new
    @task = current_user.tasks.build
  end

  def search
    @tasks = current_user.tasks.search_tasks(search_title_param, status_param).page(params[:page]).per(10)
    @search_params = { search_title: search_title_param, status: status_param }
    render 'index'
  end

  def index
    @user = current_user
    @q = current_user.tasks.ransack(params[:q])
    if params.dig(:search).present?
      @search_params = {
        search_title: search_title_param,
        status: status_param,
        label_id: label_id_param
      }
      @tasks = @q.result(distinct: true).search_tasks(
        search_title_param,
        status_param,
        label_id_param
      ).page(params[:page]).per(10)
      @labels = current_user.labels
    else
      case params[:sort]
      when 'deadline_on_asc'
        @tasks = @q.result(distinct: true).order(deadline_on: :asc, created_at: :desc).page(params[:page]).per(10)
      when 'priority_desc'
        @tasks = @q.result(distinct: true).order(priority: :desc, created_at: :desc).page(params[:page]).per(10)
      else
        @tasks = @q.result(distinct: true).order(created_at: :desc).page(params[:page]).per(10)
      end
    end
  end

  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      redirect_to tasks_path
    else
      flash.now[:alert] = t('.please_select_status_and_label')
      render :new
    end 
  end

  def edit
    @task = current_user.tasks.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = '本人以外アクセスできません'
    redirect_to tasks_path
  end

  def update
    @task = current_user.tasks.find(params[:id])
  
    if params[:task][:label_ids].present?
      label_ids = params[:task][:label_ids].reject(&:blank?).map(&:to_i)
      if label_ids.any?(&:zero?)
        flash.now[:alert] = "Invalid label ID"
        render :edit
        return
      end
      labels = Label.where(id: label_ids)
      if labels.count != label_ids.count
        missing_label_ids = label_ids - labels.pluck(:id)
        flash.now[:alert] = "Couldn't find all Labels with 'id': #{missing_label_ids.join(', ')}"
        render :edit
        return
      end
    else
      labels = []
    end
  
    if @task.label_belongs_to_user(label_ids)
      if @task.update(task_params)
        redirect_to task_path(@task), notice: t('.updated')
      else
        flash.now[:alert] = t('.please_select_status_and_label')
        render :edit
      end
    else
      flash.now[:alert] = "Label doesn't belong to user"
      render :edit
    end
  end

  def destroy
    @task = current_user.tasks.find(params[:id])
    @task.destroy
    redirect_to tasks_url, notice: t('.destroyed')
  end

  def destroy_user_tasks
    current_user.tasks.destroy_all
    redirect_to tasks_url, notice: t('.destroyed')
  end

  private

  def task_params
    params.require(:task).permit(:title, :content, :deadline_on, :priority, :status, { label_ids: [] })
  end

  def search_title_param
    params.dig(:search, :search_title)&.strip
  end

  def status_param
    params.dig(:search, :status)
  end

  def label_id_param
    params.dig(:search, :label_id)&.split(',')&.reject(&:blank?)&.map(&:to_i)
  end

  def require_login
    unless logged_in?
      flash[:alert] = t('common.please_log_in')
      redirect_to new_session_path
    end
  end

  def logged_in?
    current_user.present?
  end

  def correct_user
    unless current_user == Task.find(params[:id]).user
      redirect_to tasks_path, alert: '本人以外アクセスできません'
    end
  end
end
