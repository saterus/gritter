class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user

  def current_user
    @current_user ||= User.find(username: session[:username]) if session[:username]
  end

  def require_login
    redirect_to new_session_path, alert: 'You must login to continue.' unless current_user
  end
end
