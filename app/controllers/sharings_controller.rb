class SharingsController < ApplicationController
  before_action :set_sharing

  def index
    @sharings = policy_scope(Sharing).all
  end

  def new
    @sharing = Sharing.new
    authorize @sharing
  end

  def create
    @sharing = Sharing.new(sharing_params)
    @sharing.movie = @movie
    @sharing.user = current_user
    authorize @sharing
    if @sharing.save
      redirect_to sharings_path
    else
      render :new
    end
  end

  private

  def sharing_params
    params.require(:sharing).permit(:description, :cancelled?)
  end

  def set_sharing
    @sharing = Sharing.find(params[:id])
  end

end
