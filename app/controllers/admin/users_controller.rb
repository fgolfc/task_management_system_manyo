class Admin::UsersController < ApplicationController
  before_action :correct_user, only: [:edit, :update]
  before_action :require_admin, only: [:index, :destroy, :edit, :update, :create, :show, :new, :toggle_admin]

  def new
    @user = User.new
  end

  def index
    @users = User.all
  end

  def admin_index
    @admin_users = User.where(admin: true)
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to admin_users_path, notice: t('.created')
    else
      flash.now[:alert] = t('admin.users.create_failed')
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

    if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end

    if @user.update(user_params)
      redirect_to admin_users_path, notice: t('.updated')
    else
      if User.where(admin: true).count == 1
        flash[:alert] = '管理者権限を持つアカウントが0件になるため更新できません'
      end
      render 'admin/users/edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
  
    if @user.admin? && User.where(admin: true).count == 1
      flash[:alert] = '管理者権限を持つアカウントが0件になるため削除できません'
      redirect_to admin_users_path
    elsif current_user == @user
      redirect_to admin_users_path, flash: { error: t('common.access_denied') }
    else
      if @user.tasks.delete_all && @user.destroy
        redirect_to admin_users_path, notice: t('.destroyed')
      else
        redirect_to admin_users_path, alert: t('.destroy_failed')
      end
    end
  end

  def toggle_admin
    @user = User.find(params[:id])
    @user.toggle(:admin)
    @user.save
    redirect_to admin_user_path(@user)
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
  end

  def correct_user
    @user = User.find(params[:id])

    unless current_user.admin? || (@user == current_user)
      redirect_to admin_users_path, flash: { error: t('common.access_denied') }
    end
  end

  def require_admin
    unless current_user&.admin?
      flash[:alert] = '管理者以外アクセスできません'
      redirect_to tasks_path, alert: '管理者以外アクセスできません'
    end
  end
end