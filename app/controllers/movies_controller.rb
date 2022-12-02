class MoviesController < ApplicationController
  before_action :set_movie, only: [:show]

  def index
    @movies = policy_scope(Movie).all
    @top_rated_movies = @movies.top_rated
    @sorties_semaine = @movies.sorties_semaine
  end

  def show
    authorize @movie

    @cinemas = @movie.cinemas.geocoded

    @markers = @cinemas.map do |cinema|
      sessions = Session.where(cinema: cinema, movie: @movie).where("start_at > ?", Time.now.beginning_of_day).where("start_at < ?", Time.now.end_of_day)
      {
        lat: cinema.latitude,
        lng: cinema.longitude,
        cinema_id: cinema.id
        # info_window: render_to_string(partial: "info_window", locals: {cinema: cinema, movie: @movie, sessions: sessions, sharing: Sharing.new })
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
