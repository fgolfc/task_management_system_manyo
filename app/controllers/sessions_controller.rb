class SessionsController < ApplicationController
  include SessionsHelper
  before_action :login_required, except: [:new, :create]

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in(user)
      flash[:notice] = 'ログインしました'
      redirect_to tasks_path
    else
      flash.now[:alert] = 'ログインに失敗しました'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to tasks_path, notice: 'ログアウトしました'
  end

  private

  def login_required
    unless logged_in?
      store_location
      flash[:alert] = "ログインしてください"
      redirect_to new_session_path
    end
  end
end