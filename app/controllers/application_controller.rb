class ApplicationController < ActionController::Base
  helper_method :current_user

  def already_login?
    if current_user
      redirect_to user_path, notice: "You're already logged in"
    end
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def log_in(user)
    session[:user_id] = user.id
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

  def admin_user
    unless current_user && current_user.admin?
      redirect_to root_url
    end
  end

  def require_admin
    unless current_user && current_user.admin?
      redirect_to root_url
    end
  end
end
