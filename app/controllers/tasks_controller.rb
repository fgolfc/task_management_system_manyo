class TasksController < ApplicationController
  before_action :require_login
  before_action :correct_user, only: [:show, :edit, :update, :destroy]

  def show
    @task = current_user.tasks.find(params[:id])
  end  

  def new
    @task = current_user.tasks.build
    @labels = current_user.labels
  end
  
  def create
    @task = current_user.tasks.build(task_params)
    @labels = current_user.labels
    label_ids = params[:task][:label_ids].reject(&:blank?).map(&:to_i)
    labels = Label.where(id: label_ids)
    @task.labels = labels
    
    if @task.save
      flash[:notice] = 'タスクを作成しました'
      redirect_to tasks_path
    else
      @tasks = Task.all
      render :new
    end
  end

  def index
    search_params = params[:search] || {}
    @user = current_user
    if params.dig(:search).present?
      @tasks = current_user.tasks.includes(:labels).search_tasks(search_title_param, status_param, search_label_param).order(created_at: :desc)
  
      case params[:sort]
      when 'deadline_on_asc'
        @tasks = @tasks.order(deadline_on: :asc)
      when 'priority_desc'
        @tasks = @tasks.order(priority: :desc)
      end
  
      @tasks = @tasks.page(params[:page]).per(10)
    else
      case params[:sort]
      when 'deadline_on_asc'
        @tasks = current_user.tasks.includes(:labels).order(deadline_on: :asc, created_at: :desc)
      when 'priority_desc'
        @tasks = current_user.tasks.includes(:labels).order(priority: :desc, created_at: :desc)
      else
        @tasks = current_user.tasks.includes(:labels).order(created_at: :desc)
      end
  
      @tasks = @tasks.page(params[:page]).per(10)
    end
  end
  

  def edit
    @task = current_user.tasks.find(params[:id])
    @labels = current_user.labels
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = '本人以外アクセスできません'
    redirect_to tasks_path
  end

  def update
    @task = current_user.tasks.find(params[:id])
  
    label_ids = params[:task][:label_ids].reject(&:blank?).map(&:to_i)
    labels = Label.where(id: label_ids)
  
    if label_ids.any?(&:zero?) || labels.count != label_ids.count
      flash.now[:alert] = "Invalid label ID"
      render :edit
      return
    end
  
    if @task.update(task_params.merge(label_ids: label_ids))
      redirect_to task_path(@task), notice: t('.updated')
    else
      flash.now[:alert] = t('.please_select_status_and_label')
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
    params.require(:task).permit(:title, :content, :deadline_on, :priority, :status, :label_id)
  end

  def search_title_param
    params.dig(:search, :search_title)
  end

  def search_label_param
    params.dig(:search, :label_ids) || []
  end

  def status_param
    params.dig(:search, :status)
  end
  
  def label_id_param
    params.dig(:search, :label_id)
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