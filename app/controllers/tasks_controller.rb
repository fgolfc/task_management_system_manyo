class TasksController < ApplicationController
  
  def show
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def search
    @tasks = Task.search_tasks(params[:search_title], params[:status]).page(params[:page]).per(10)
    render 'index'
  end

  def index
    if params[:search].present?
      @tasks = Task.search_tasks(params[:search], nil).page(params[:page]).per(10)
      @search_params = params[:search]
      @status_params = nil
    else
      case params[:sort]
      when 'deadline_asc'
        @tasks = Task.all.order(deadline: :asc).page(params[:page]).per(10)
      when 'priority_desc'
        @tasks = Task.all.order(priority: :desc, created_at: :desc).page(params[:page]).per(10)
      else
        @tasks = Task.all.order(created_at: :desc).page(params[:page]).per(10)
      end
      @search_params = nil
      @status_params = params[:status]
    end
  end

  def create
    @task = Task.new(task_params)
    if @task.valid?
      @task.save!
      redirect_to tasks_path
    else
      render :new
    end
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])

    if @task.update(task_params)
      redirect_to task_path(@task), notice: t('.updated')
    else
      render :edit
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    redirect_to tasks_url, notice: t('.destroyed')
  end

  private

  def task_params
    params.require(:task).permit(:title, :content, :deadline, :priority, :status)
  end
end
