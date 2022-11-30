require 'rest-client'

class GetMovieDetails

  def initialize(movie_id)
    @url = "https://api.themoviedb.org/3/movie/#{movie_id}"
  end

  def call
    response_details = RestClient.get(@url, { params: params_details })
    JSON.parse(response_details)
  end

  private

  def params_details
    {
      api_key: ENV["TMDB_API_KEY"],
      language: "fr-FR",
    }
  end

end
