class GritsController < ApplicationController
  before_filter :require_login

  def index
    @grits = Neo4j.query(current_user){ |u|
      u > User.following > node(:followed) < Grit.author < node(:g).desc(:created_at).limit(25)
      ret(:g)
    }.to_a.map{|res| res[:g] }

    if @grits.empty?
      @grits = Grit.find(:all).take(50)
      flash[:notice] = 'You should follow someone to get a customized timeline.'
    end
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
