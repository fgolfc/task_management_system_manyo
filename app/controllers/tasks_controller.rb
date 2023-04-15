class TasksController < ApplicationController
  before_action :require_login
  before_action :correct_user, only: [:show, :edit, :update, :destroy]

  def show
    @task = current_user.tasks.find(params[:id])
    if current_user == @task.user
    else 
      redirect_to tasks_path, alert: '本人以外アクセスできません'
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
    @search_params = { search_title: search_title_param, status: status_param }
    @user = current_user # 現在のユーザーを取得するためにこの行を追加する
    if params.dig(:search).present?
      @tasks = current_user.tasks.search_tasks(search_title_param, status_param).page(params[:page]).per(10)
    else
      case params[:sort]
      when 'deadline_on_asc'
        @tasks = current_user.tasks.order(deadline_on: :asc, created_at: :desc).page(params[:page]).per(10)
      when 'priority_desc'
        @tasks = current_user.tasks.order(priority: :desc, created_at: :desc).page(params[:page]).per(10)
      else
        @tasks = current_user.tasks.order(created_at: :desc).page(params[:page]).per(10)
      end
    end
  end

  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      redirect_to tasks_path
    else
      flash.now[:alert] = t('.please_select_status')
      render :new
    end
  end

  def edit
    @task = current_user.tasks.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to tasks_path, alert: '本人以外アクセスできません'
  end

  def update
    @task = current_user.tasks.find(params[:id])

    if @task.update(task_params)
      redirect_to task_path(@task), notice: t('.updated')
    else
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
    params.require(:task).permit(:title, :content, :deadline_on, :priority, :status)
          .merge(user_id: current_user.id)
  end

  def search_title_param
    params.dig(:search, :search_title)&.strip
  end

  def status_param
    params.dig(:search, :status)
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