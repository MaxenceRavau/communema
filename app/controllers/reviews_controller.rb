class ReviewsController < ApplicationController

  def index
    @review = Review.all
  end

  def new
    @movie = Movie.find(params[:movie_id])
    @review = Review.new
    authorize @review
  end

  def create
    @review = Review.new(review_params)
    @review.movie = Movie.find(params[:movie_id])
    @review.user = current_user
    authorize @review
    if @review.save
      redirect_to sharings_path
    else
      render :new
    end
  end

  private

  def review_params
    params.require(:review).permit(:comment, :rating)
  end
end
