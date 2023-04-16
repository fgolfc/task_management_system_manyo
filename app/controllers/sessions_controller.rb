class SessionsController < ApplicationController
  include SessionsHelper
  before_action :require_login, only: [:destroy]

  def new
    redirect_to tasks_path if logged_in?
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in(user)
      flash[:notice] = 'ログインしました'
      redirect_to tasks_path
    else
      flash.now[:alert] = 'メールアドレスまたはパスワードに誤りがあります'
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to new_session_path, notice: 'ログアウトしました'
  end

  private

  def require_login
    unless logged_in?
      store_location
      flash[:alert] = "ログインしてください"
      redirect_to new_session_path
    end
  end
end