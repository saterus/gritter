class SessionsController < ApplicationController

  def new
    @user = User.new
  end

  def create
    user = UserAuthenticator.authenticate(params[:user][:username], params[:user][:password])
    if user
      session[:username] = user.username
      flash[:notice] = "Login successful."
      redirect_to root_path
    else
      @user = User.new(username: params[:username])
      flash[:alert] = "Login failed. Please check your username and password again."
      render :new
    end
  end

  def destroy
    session[:username] = nil
    @current_user = nil
    flash[:notice] = "Logout successful."
    redirect_to root_path
  end

end
