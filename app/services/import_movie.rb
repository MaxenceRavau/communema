require "open-uri"

class ImportMovie

  def initialize(movie_info)
    @movie_info = movie_info
  end

  def call
    @movie_details = GetMovieDetails.new(@movie_info.id).call
    puts "Création du #{@movie_info.original_title}..."
    new_movie = Movie.create(
      title: @movie_info.original_title,
      synopsis: @movie_info.overview,
      genre: @movie_details['genres'].first&.fetch('name'),
      release_date: @movie_info.release_date,
      duration: @movie_details['runtime'],
      market_rating: @movie_info.vote_average,
      tmdb_id: @movie_details['id']
    )

    return if @movie_info.poster_path.blank?

    file = URI.open("https://image.tmdb.org/t/p/w500#{@movie_info.poster_path}")
    new_movie.photo.attach(io: file, filename: "nes.png", content_type: "image/png")
    new_movie.save
  end

end
