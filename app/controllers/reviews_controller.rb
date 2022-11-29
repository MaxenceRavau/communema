class ReviewsController < ApplicationController
  def index
    @reviews = policy_scope(Review).all
  end

  def new
    @review = Review.new
    authorize @review
  end

  def create
    @review = Review.new(review_params)
    @review.movie = @movie
    @review.user = current_user
    authorize @review
    if @review.save
      redirect_to reviews_path
    else
      render :new
    end
  end

  private

  def review_params
    params.require(:review).permit(:comment, :rating)
  end
end
