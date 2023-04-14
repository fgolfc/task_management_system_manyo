class UsersController < ApplicationController
  before_action :require_admin, only: [:index, :destroy]
  before_action :correct_user, only: [:show, :edit, :update, :destroy]

  def new
    @user = User.new
  end
  
  def index
    if current_user.admin?
      @users = User.all
    else
      redirect_to tasks_path, notice: "管理者以外アクセスできません"
    end
  end

  def admin_index
    @admin_users = User.where(admin: true)
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in(@user)
      redirect_to tasks_path, notice: t('.created')
    else
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if params[:user][:password].blank? && params[:user][:password_confirmation].blank? && current_user == @user
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end
    if @user.update(user_params)
      redirect_to user_path(@user), notice: t('.updated')
    else
      render :edit
    end
  end

  def show
    @user = User.find(params[:id])
    correct_user
  end
  
  def destroy
    @user = User.find(params[:id])
    if current_user.admin?
      if current_user == @user
        redirect_to users_path, flash: { error: t('common.access_denied') }
      else
        @user.tasks.destroy_all
        if @user.destroy
          redirect_to users_path, notice: t('.destroyed')
        else
          redirect_to users_path, alert: t('.destroy_failed')
        end
      end
    elsif current_user == @user
      redirect_to users_path, flash: { error: t('common.access_denied') }
    else
      redirect_to users_path, alert: t('common.access_denied')
    end
  end
  
  def authenticate_user!
    unless current_user
      flash[:alert] = t('common.please_log_in')
      redirect_to new_session_path
    end
  end
  
  def toggle_admin
    @user = User.find(params[:id])
    @user.toggle(:admin)
    @user.save
    redirect_to admin_user_path
  end

  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
  
  def correct_user
    @user = User.find(params[:id])
    if !current_user || (!current_user.admin? && current_user != @user)
      redirect_to tasks_path, alert: '管理者以外アクセスできません'
    end
  end
  
  def require_admin
    unless current_user && current_user.admin?
      flash[:alert] = '管理者以外アクセスできません'
      redirect_to tasks_path
    end
  end
end