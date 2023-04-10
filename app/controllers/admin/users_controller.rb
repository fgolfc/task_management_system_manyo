class Admin::UsersController < ApplicationController
  before_action :require_admin, only: [:index, :destroy]
  before_action :authenticate_user!, except: [:new, :create]
  before_action :correct_user, only: [:edit, :update]

  def new
    @user = User.new
  end

  def index
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
  
  def show
    @user = User.find(params[:id])
    @tasks = @user.tasks.page(params[:page]).per(10)
  end
  
  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if params[:user][:password].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end
    if @user.update(user_params)
      if current_user.admin?
        @user.update_attribute(:admin, params[:user][:admin])
      end
      redirect_to users_path, notice: t('.updated')
    else
      render :edit
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    if current_user.admin?
      if current_user == @user
        redirect_to users_path, flash: { error: t('common.access_denied') }
      else
        if @user.tasks.delete_all && @user.destroy
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

  def find_user(email, password)
    user = User.find_by(email: email)
    if user && user.authenticate(password)
      return user
    else
      return nil
    end
  end
  
  def authenticate_user!
    unless current_user
      flash[:alert] = t('common.please_log_in')
      redirect_to new_session_path
    else
      @user = User.find(params[:id])
      unless current_user.admin? || current_user == @user
        flash[:alert] = t('common.access_denied')
        redirect_to root_path
      end
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
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user.admin? || current_user == @user 
  end
end