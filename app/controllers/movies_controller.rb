class MoviesController < ApplicationController
  before_action :set_movie, only: [:show]

  def index
    @movies = policy_scope(Movie).all
    @top_rated_movies = @movies.top_rated
    @sorties_semaine = @movies.sorties_semaine
    @selected_movies = Movie.where(tmdb_id: ["436270", "505642", "791177", "615952", "837881", "944303", "872709", "998783", "971594", "998783", "899112", "785980", "664469", "918044","865498"])
  end

  def show
    authorize @movie

    @cinemas = @movie.cinemas.geocoded
    @reviews = Review.all

    @markers = @cinemas.map do |cinema|
      @sessions = Session.where(cinema: cinema, movie: @movie).where("start_at > ?", Time.now.beginning_of_day).where("start_at < ?", Time.now.end_of_day)
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
