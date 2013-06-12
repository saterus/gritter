class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user

  def current_user
    @current_user ||= (session[:username] && User.find(username: session[:username]))
  end
end
