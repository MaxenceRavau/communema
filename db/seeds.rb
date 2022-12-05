require "json"
require "open-uri"

Sharing.destroy_all
Cinema.destroy_all
Follow.destroy_all
Review.destroy_all
User.destroy_all
Movie.destroy_all

puts "destroying..."

# ---- Users ----

ParsingStudents.new.call

User.all.each do |user|
  User.where.not(id: user.id).each do |buddy|
    Follow.create(
      follower: user,
      followee: buddy
    )
  end
end

# # @test_user.each do |user|
# #   Follow.create!(
# #     email:
# #   )
# # end

# bob = User.create!(email: "bob@mail.com", password: '123456', first_name: 'Bob', last_name: 'Kiffeur')
# mark = User.create!(email: "mark@mail.com", password: '123456', first_name: 'Mark')
# nico = User.create!(email: "nico@mail.com", password: '123456', first_name: 'Nico')

# # ---- Followers & Followees ----

# Follow.create!(follower: bob, followee: mark)
# Follow.create!(follower: bob, followee: nico)

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

# tmdb_ids = Movie.limit(10).pluck(:tmdb_id)

tmdb_ids = ["436270", "505642", "791177", "615952", "837881", "944303", "872709", "998783", "971594", "998783", "899112", "785980", "664469", "918044","865498"]

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

# ---- Création de sessions historiques ----
cinema = Cinema.first
movies.each do |movie|
  start_at = Time.parse(Date.today.strftime('%y/%m/%d') + " 20:00") - 7.days
  # session = Session.create(movie: movie, cinema: cinema, start_at: start_at)
  User.all.shuffle.first(rand(6..10)).each do |user|
    Review.create(movie: movie, rating: [3, 4, 5].sample, user: user, comment: ["top", "bien"].sample)
  end
end

# ---- Dans chaque cine, pour chaque film, on crée une session ----

sessions = []

cinemas.each do |cinema|
  movies.each do |movie|
    session_plannings.sample.each do |starting_hour|
      4.times do |i|
        puts "Création d'une session"
        start_at = Time.parse(Date.today.strftime('%y/%m/%d') + " #{starting_hour}") + i.days
        sessions.push(Session.create(movie: movie, cinema: cinema, start_at: start_at))
      end
    end
  end
end

# ---- On crée deux sharings pour user.first ----

shared_sessions = sessions.shuffle.first(2)
shared_sessions.each do |session|
  Sharing.create!(session: session, user: User.first, description: 'Trop envie de voir ce truc')
end
