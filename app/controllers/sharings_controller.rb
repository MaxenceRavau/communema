class SharingsController < ApplicationController

  def show
    @sharing = Sharing.find(params[:id])
    @message = Message.new
    authorize @sharing
  end

  def index
    @sharings = policy_scope(current_user.sharings)
    followed_users_sharings = Sharing.where(user: current_user.followed_users)
    @movie

  end

  def create
    @sharing = Sharing.new(sharing_params)
    @sharing.session = params[session_id]
    @sharing.user = current_user
    authorize @sharing
    if @sharing.save
      redirect_to sharings_path
    else
      redirect_to movie_path(@sharing.movie)
    end
  end

  private

  def sharing_params
    params.require(:sharing).permit(:description, :cancelled?)
  end
end
