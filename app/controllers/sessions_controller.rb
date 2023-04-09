class SessionsController < ApplicationController
  include SessionsHelper
  before_action :login_required, except: [:new, :create]

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      log_in user
      redirect_back_or tasks_path, notice: 'ログインしました'
    else
      flash.now[:danger] = 'メールアドレスまたはパスワードに誤りがあります'
      render :new
    end
  end

  def destroy
    log_out
    flash[:notice] = 'ログアウトしました'
    redirect_back_or new_session_path
  end

  private

  def login_required
    unless logged_in?
      store_location
      flash[:alert] = "ログインしてください"
      redirect_to new_users_path
    end
  end
end