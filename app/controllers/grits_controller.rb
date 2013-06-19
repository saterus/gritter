class GritsController < ApplicationController
  before_filter :require_login

  def index
    @grits = current_user.full_timeline
  end

  def show
    @grit = Grit.find(params[:id])
  end

  def new
    @grit = Grit.new
  end

  def create
    @grit = current_user.grits.build(params[:grit].slice(:body))
    @grit.previous = current_user.latest_grit
    current_user.latest_grit = @grit
    if @grit.save && current_user.save
      render :show
    else
      render :new
    end
  end
end
