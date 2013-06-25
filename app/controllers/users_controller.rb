class UsersController < ApplicationController
  class SelfFollowException < Exception; end
  class AlreadyFollowingException < Exception; end
  class NotFollowingException < Exception; end

  respond_to :html, :json

  before_filter :require_login, except: [:index]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @grits = @user.grits.sort_by(&:created_at)
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update_attributes(params[:user].slice(:name, :bio))
      flash[:notice] = "Successfully updated your profile."
      redirect_to :show
    else
      flash[:alert] = "Oh no! Something went wrong. Please try again."
      render :edit
    end
  end

  def follow
    follower = current_user
    followee = User.find(params[:id])

    raise SelfFollowException if follower == followee
    raise AlreadyFollowingException if followee.followers.include?(follower)

    # I'd love to use:
    # Neo4j.query(follower, followee) do |me, them|
    #   create_unique_path{ me > User.following > them }
    # end

    followee.followers << follower
    followee.save
    respond_with followee
  end

  def unfollow
    follower = current_user
    followee = User.find(params[:id])

    raise SelfFollowException if follower == followee
    raise NotFollowingException unless followee.followers.include?(follower)

    followee.followers.delete(follower)
    followee.save
    respond_with followee
  end

end
