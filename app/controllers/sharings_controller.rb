class SharingsController < ApplicationController

  def show
    @sharing = Sharing.find(params[:id])
    @message = Message.new
    authorize @sharing
  end

  def index
    @review = Review.new
    @sharings = policy_scope(current_user.sharings).order(created_at: :desc)
    @followed_users_sharings = Sharing.where(user: current_user.followed_users).order(created_at: :desc)
    @attendee = Attendee.new
    @attendees = Attendee.all
  end

  def create
    @sharing = Sharing.new(sharing_params)
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
    params.require(:sharing).permit(:description, :session_id)
  end
end
