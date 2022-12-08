class MoviesController < ApplicationController
  before_action :set_movie, only: [:show]

  def index
    @movies = policy_scope(Movie).all
    @top_rated_movies = @movies.top_rated
    @sorties_semaine = @movies.sorties_semaine.joins("left outer join reviews on reviews.movie_id = movies.id").select('movies.*, AVG(reviews.rating) AS average_rating').where("reviews.user_id IS NULL OR reviews.user_id IN (?)", current_user.followed_users.pluck(:id)).group('movies.id').order("average_rating DESC NULLS LAST")
    @selected_movies = Movie.joins("left outer join reviews on reviews.movie_id = movies.id").select('movies.*, AVG(reviews.rating) AS average_rating').where("reviews.user_id IS NULL OR reviews.user_id IN (?)", current_user.followed_users.pluck(:id)).group('movies.id').order("average_rating DESC NULLS LAST").limit(12)
    # @selected_movies = Movie.joins(:reviews).select('movies.*, AVG(reviews.rating) AS average_rating').where(reviews: { user: current_user.followed_users }).group('movies.id').order(average_rating: :desc)
    # @selected_movies = Movie.where(tmdb_id: ["436270", "505642", "791177", "615952", "837881", "944303", "872709", "998783", "971594", "998783", "899112", "785980", "664469", "918044","865498"])
    @cinemas = Cinema.all
  end

  def show
    authorize @movie

    @cinemas = @movie.cinemas.geocoded.near([48.8647757, 2.3797682], 5)
    @reviews = @movie.reviews.order(created_at: :desc)

    @sharings = @movie.sharings_of_followed_users(current_user)

    @markers = @cinemas.map do |cinema|
      # @sessions = Session.where(cinema: cinema, movie: @movie).where("start_at > ?", Time.now.beginning_of_day).where("start_at < ?", Time.now.end_of_day)
      {
        lat: cinema.latitude,
        lng: cinema.longitude,
        cinema_id: cinema.id,
        image_url: helpers.asset_url("marker.svg")
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
