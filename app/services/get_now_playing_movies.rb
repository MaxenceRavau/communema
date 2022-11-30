require 'rest-client'

class GetNowPlayingMovies

  def initialize
    @url = "https://api.themoviedb.org/3/movie/now_playing"
  end

  def call
    response = api_call
    movies = response['results']
    total_pages = response['total_pages']

    (2..total_pages).each do |page|
      response = api_call(page)
      movies.push(response['results']).flatten!
    end

    return movies.map { |movie_hash| OpenStruct.new(movie_hash) }
  end

  private

  def api_call(page = 1)
    puts "API call for page #{page}..."
    response = RestClient.get(@url, { params: params(page)})
    JSON.parse(response)
  end

  def params(page)
    {
      api_key: ENV["TMDB_API_KEY"],
      region: "FR",
      language: "fr-FR",
      page: page
    }
  end

end
