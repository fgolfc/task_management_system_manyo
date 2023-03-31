class SessionsController < ApplicationController
  before_action :login_required
  skip_before_action :login_required, only: [:new, :create]
  def new
  end
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      session[:user_id] = user.id
      redirect_to tasks_path, notice: 'ログインしました'
    else
      flash.now[:danger] = 'メールアドレスまたはパスワードに誤りがあります'
      render :new
    end
  end
  def destroy
    session.delete(:user_id)
    flash[:notice] = 'ログアウトしました'
    redirect_to new_session_path
  end

  private

  def login_required
    redirect_to new_session_path unless current_user
    flash[:notice] = "ログインしてください"
  end
end