class SharingsController < ApplicationController

  def index
    @sharings = policy_scope(current_user.sharings)
    followed_users_sharings = Sharing.where(user: current_user.followed_users)
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


end
