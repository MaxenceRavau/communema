Cinema.destroy_all
User.destroy_all
Movie.destroy_all
Follow.destroy_all

puts "destroying..."

require "json"

# ---- Users ----

bob = User.create!(email: "bob@mail.com", password: '123456', first_name: 'Bob', last_name: 'Kiffeur')
mark = User.create!(email: "mark@mail.com", password: '123456', first_name: 'Mark')
nico = User.create!(email: "nico@mail.com", password: '123456', first_name: 'Nico')

# ---- Followers & Followees ----

Follow.create!(follower: bob, followee: mark)
Follow.create!(follower: bob, followee: nico)

# ---- Parsing des salles de cine en Ile de France ----

filepath = "db/salles.json"
serialized_salles = File.read(filepath)
@salles = JSON.parse(serialized_salles)

@salles.each do |salle|
  next if salle["fields"]["entrees_2020"] < 200_000

  puts "Creation du ciné #{salle["fields"]["nom"]}..."
  Cinema.create!(
    name: salle["fields"]["nom"],
    brand: salle["fields"]["programmateur"],
    location: salle["fields"]["adresse"] + " " + salle["fields"]["commune"],
    latitude: salle["fields"]["geo"][0],
    longitude: salle["fields"]["geo"][1]
  )
end

# ---- Selection des films tmdb en FR et en ENG ----

tmdb_movies = GetNowPlayingMovies.new.call

tmdb_movies.select! do |movie_info|
  movie_info.original_language.in? ["fr", "en"]
end

# ---- Pour chacun des films sélectionnés ci-dessus, on ajoute les données qui vont bien. On crée des films ----

tmdb_movies.each do |movie_info|
  ImportMovie.new(movie_info).call
end

# ---- mettre une 10aine de tmdb_id dans l'array ----

tmdb_ids = Movie.limit(10).pluck(:tmdb_id)

# ---- On récupère les movies qui correspondent aux ids ci-dessus. Instances de movies ----

movies = Movie.where(tmdb_id: tmdb_ids)

# ---- On crée les séances types ----

session_plannings = [
  ['14:00', '16:30', '19:00', '21:30'],
  ['15:00', '17:30', '20:00', '22:30'],
  ['14:45', '18:00', '21:15'],
  ['13:30', '16:15', '19:55']
]

# ---- On appelle les cinémas qu'on a parsé plus haut dans un array cinemas ----

cinemas = Cinema.all # à voir si on le fait pas sur une sélection de cinémas seulement

# ---- Dans chaque cine, pour chaque film, on crée une session ----

cinemas.each do |cinema|
  movies.each do |movie|
    session_plannings.sample.each do |starting_hour|
      4.times do |i|
        puts "Création d'un session"
        start_at = Time.parse(Date.today.strftime('%y/%m/%d') + " #{starting_hour}") + i.days
        Session.create(movie: movie, cinema: cinema, start_at: start_at)
      end
    end
  end
end

# ---- On crée deux sharings pour Bob ----

bob_sessions = Session.all.shuffle.first(2)
bob_sessions.each do |session|
  Sharing.create!(session: session, user: bob, description: 'Trop envie de voir ce truc')
end

# ---- On crée 4 sharings pour les followees de Bob, au pif ----

Session.where.not(id: bob_sessions.map(&:id)).shuffle.first(4).each do |session|
  Sharing.create!(session: session, user: [mark, nico].sample, description: 'Vous venez ?')
end
