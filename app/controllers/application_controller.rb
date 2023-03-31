class ApplicationController < ActionController::Base
  include SessionsHelper
  before_action :login_required
  add_flash_types :notice, :error, :warning

  private

  def login_required
    redirect_to new_session_path unless current_user
    flash[:notice] = "ログインしてください"
  end
end

