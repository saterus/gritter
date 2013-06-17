class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update_attributes(params[:user].slice(:name, :bio))
      flash[:notice] = "Successfully updated your profile."
      render :show
    else
      flash[:alert] = "Oh no! Something went wrong. Please try again."
      render :edit
    end
  end
end
