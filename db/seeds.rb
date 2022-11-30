Cinema.destroy_all
User.destroy_all
Movie.destroy_all
Follow.destroy_all

require "json"

# ---- Users ----

hamza = User.create(first_name: "Hamza", last_name:"Triqui", email:"test@g.com", password:"123456")
hamza.save
puts "destroying..."

# ---- Parsing des salles de cine en Ile de France ----

filepath = "db/salles.json"
serialized_salles = File.read(filepath)
@salles = JSON.parse(serialized_salles)

@salles.each do |salle|
  next if salle["fields"]["entrees_2020"] < 100_000
    new_cinema = Cinema.create(
      name: salle["fields"]["nom"],
      brand: salle["fields"]["programmateur"],
      location: salle["fields"]["adresse"] & " " & salle["fields"]["commune"]
    )
end

# ---- Selection des films tmdb en FR et en ENG ----

tmdb_movies = GetNowPlayingMovies.new.call

tmdb_movies.select! do |movie_info|
  movie_info.original_language.in? ["fr", "en"]
end

# ---- Pour chacun des films sélectionnés ci-dessus, on ajoute les données qui vont bien ----

tmdb_movies.each do |movie_info|
  ImportMovie.new(movie_info).call
end

# ---- mettre une 10aine de tmdb_id dans l'array ----

tmdb_ids = []
10.times do
  tmdb_movies.each do |movie_details|
    tmdb_ids.push(movie_details["id"])
  end
end

# ---- je ne comprends pas l'égalité ci-dessous ----

movies = Movies.where(tmdb_id: tmdb_ids)

# ---- On crée les séances types ----

session_plannings = [
  ['14h', '16h30', '19h', '21h30'],
  ['15h', '17h30', '20h', '22h30'],
  ['14h45', '18h00', '21h15'],
  ['13h30', '16h15', '19h55']
]

# ---- On appelle les cinémas qu'on a parsé ci-dessus dans un array cinemas ----

cinemas = Cinema.all # à voir si on le fait pas sur une sélection de cinémas seulement

# ---- Dans chaque cine, pour chaque film, on crée une session ----

cinemas.each do |cinema|
  movies.each do |movie|
    session_plannings.sample.each do |starting_time|
      Session.create(movie_id: movie.id, cinema_id: cinema.id, start_at: starting_time)
    end
  end
end
