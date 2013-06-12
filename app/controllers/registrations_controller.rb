class RegistrationsController < ApplicationController

  def new
    @registration = Registration.new
  end

  def create
    @registration = Registration.new(params[:registration])
    if @registration.save
      session[:username] = @registration.username
      flash[:notice] = "Account created. Welcome #{@registration.name}!"
      redirect_to root_path
    else
      @registration.password = nil
      @registration.password_confirmation = nil
      render :new
    end
  end

end
