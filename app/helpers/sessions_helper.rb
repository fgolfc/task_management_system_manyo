module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !current_user.nil?
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

  def redirect_back_or(default_path, notice: nil)
    flash[:notice] = notice if notice
    redirect_to(session[:return_to] || default_path)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.original_url if request.get?
  end
end