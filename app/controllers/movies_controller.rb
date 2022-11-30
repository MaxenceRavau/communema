class MoviesController < ApplicationController
  before_action :set_movie, only: [:show]

  def index
    @movies = policy_scope(Movie).all
  end

  def show
    authorize @movie

    @cinemas = @movie.cinemas

    @markers = @cinemas.geocoded.map do |cinema|
      {
        lat: cinema.latitude,
        lng: cinema.longitude
      }
    end
  end

  private

  def movie_params
    params.require(:movie).permit(:title, :synopsis, :genre, :release_date, :duration, :director, :market_rating)
  end

  def set_movie
    @movie = Movie.find(params[:id])
  end
end
