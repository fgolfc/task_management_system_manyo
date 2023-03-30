class Admin::UsersController < ApplicationController
  before_action :require_admin, only: [:index, :destroy]
  before_action :authenticate_user!, except: [:new, :create]

  def new
    @user = User.new
  end

  def index
    @users = User.all
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
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user), notice: t('.updated')
    else
      render :edit
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      if current_user.admin?
        redirect_to users_path, notice: t('.destroyed')
      else
        log_out
        redirect_to new_session_path, notice: t('.destroyed')
      end
    else
      redirect_to users_path, alert: t('.destroy_failed')
    end
  end

  def toggle_admin
    @user = User.find(params[:id])
    @user.toggle(:admin)
    @user.save
    redirect_to admin_users_path
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
  
  def require_admin
    redirect_to root_url unless current_user.admin?
  end
end