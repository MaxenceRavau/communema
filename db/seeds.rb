require "json"
require "open-uri"

puts "destroying..."

Message.destroy_all
Sharing.destroy_all
Cinema.destroy_all
Follow.destroy_all
Review.destroy_all
User.destroy_all
Movie.destroy_all

puts "DB cleared!!!"
# ---- Users ----

puts "creation des users..."
ParsingStudents.new.call


puts "creation des follows..."
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
  next if salle["fields"]["unite_urbaine_2010"] != "Paris"
  next if salle["fields"]["entrees_2020"] < 50000

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

session_plannings = [
  ['14:00', '16:30', '19:00', '21:30'],
  ['15:00', '17:30', '20:00', '22:30'],
  ['14:45', '18:00', '21:15'],
  ['13:30', '16:15', '19:55']
]

# ---- Film à rejoindre - start ----

movie_to_join = Movie.find_by(tmdb_id: "892515")

sessions = []

Cinema.all.each do |cinema|
  session_plannings.sample.each do |starting_hour|
    4.times do |i|
      puts "Création d'une session"
      start_at = Time.parse(Date.today.strftime('%y/%m/%d') + " #{starting_hour}") + i.days
      session = Session.create(movie: movie_to_join, cinema: cinema, start_at: start_at)
      sessions.push(session) if i == 1
    end
  end
end

max = User.find_by(email: "maxence.ravau@mail.com")
max_friends = max.followed_users
chosen_friend = max_friends.sample

other_friends = max_friends.where.not(id: chosen_friend.id)

attendees_users = other_friends.shuffle.sample(3)

sharing = Sharing.create!(session: sessions.first, user: chosen_friend, description: 'Qui est chaud pour aller regarder Mascarade après la teuf de fin de batch?')

attendees_users.each do |attendee_user|
  Attendee.create(user: attendee_user, sharing: sharing)
end

Message.create(
  content: 'Qui est chaud pour aller regarder Mascarade après la teuf de fin de batch?',
  user: chosen_friend,
  sharing: sharing
)

Message.create(
  content: 'Franchement pourquoi pas, je kiffe Pierre Niney',
  user: attendees_users.first,
  sharing: sharing
)

Message.create(
  content: 'Why not mais ça risque de finir tard la teuf du Wagon?',
  user: attendees_users.second,
  sharing: sharing
)

Message.create(
  content: 'Pas grave on y va à la sortie justement',
  user: attendees_users.first,
  sharing: sharing
)

Message.create(
  content: "Maxence allez chauffe toi mec, tu m'as dit que tu voulais le voir",
  user: attendees_users.third,
  sharing: sharing
)

# ---- Film à rejoindre - end ----

# ---- Film à partager - start ----

movie_to_share = Movie.find_by(tmdb_id: "872709")
friends = max_friends.shuffle.first(3)

comments = [
  "Bon film, allez y les amis, il vaut le coup d'être regardé",
  "J'ai bien aimé, je pense que je devrais le revoir une deuxième fois pour tout comprendre",
  "Top, ça faisait un bail que je n'étais pas allé au ciné",
  "Allez y sans hésiter !",
  "A voir absolument les potes"
]

friends.each_with_index do |friend, index|
  Review.create(movie: movie_to_share, rating: [4, 5].sample, user: friend, comment: comments[index])
end

Cinema.all.each do |cinema|
  session_plannings.sample.each do |starting_hour|
    # 4.times do |i|
      puts "Création d'une session"
      start_at = Time.parse(Date.today.strftime('%y/%m/%d') + " #{starting_hour}")
      session = Session.create(movie: movie_to_share, cinema: cinema, start_at: start_at)
      # sessions.push(session) if i == 1
    end
  # end
end



# ---- Film à partager - end ----

# ---- Sharing random - start ----

tmdb_ids = ["436270", "505642", "791177", "615952", "944303", "998783", "971594", "899112", "785980", "664469", "918044","865498"]

shared_movies = Movie.where(tmdb_id: tmdb_ids).sample(4)

shared_movies.each_with_index do |shared_movie, index|
  chosen_session = Session.create(movie: shared_movie, cinema: Cinema.all.sample, start_at: Time.parse((Date.today + (index + 1).days).strftime('%y/%m/%d') + " 20:00"))
  sharing_creator = max_friends.shuffle.sample
  chosen_sharing = Sharing.create(session: chosen_session, user: sharing_creator, description: 'Trop envie de voir ce film')
  attendee_users = friends.reject { |user| user == sharing_creator }.sample(rand(1..3))
  attendee_users.each do |attendee_user|
    Attendee.create(user: attendee_user, sharing: chosen_sharing)
  end
end

# chose_sharings.each do |chosen_sharing|
#   Attendee.create(user: attendees_users.sample, sharing: chosen_sharing)
# end

# cinemas = Cinema.all

# # ---- On crée des commentaires type  ----

# chosen_comments = [
#   "Bon film, allez y les amis, il vaut le coup d'être regardé",
#   "J'ai bien aimé, je pense que je devrais le revoir une deuxième fois pour tout comprendre",
#   "Top, ça faisait un bail que je n'étais pas allé au ciné",
#   "Allez y sans hésiter !",
#   "A voir absolument les potes"
# ]

# ---- Création de sessions historiques pour la liste de films ----

# cinema = Cinema.first
# chosen_movies.each do |chosen_movie|
#   start_at = Time.parse(Date.today.strftime('%y/%m/%d') + " 20:00") - 7.days
#   User.all.shuffle.first(rand(6..10)).each do |user|
#     Review.create(movie: chosen_movie, rating: [4, 5].sample, user: user, comment: chosen_comments.sample)
#   end
# end

# movies.each do |movie|
#   start_at = Time.parse(Date.today.strftime('%y/%m/%d') + " 20:00") - 7.days
#   User.all.shuffle.first(rand(6..10)).each do |user|
#     Review.create(movie: movie, rating: [3, 4, 5].sample, user: user, comment: comments.sample)
#   end
# end

# # ---- Dans chaque cine, pour chaque film, on crée une session ----

# sessions = []

# cinemas.each do |cinema|
#   movies.each do |movie|
#     session_plannings.sample.each do |starting_hour|
#       4.times do |i|
#         puts "Création d'une session"
#         start_at = Time.parse(Date.today.strftime('%y/%m/%d') + " #{starting_hour}") + i.days
#         sessions.push(Session.create(movie: movie, cinema: cinema, start_at: start_at))
#       end
#     end
#   end
# end

# # ---- On crée deux sharings pour user.first ----

# shared_sessions = sessions.shuffle.first(2)
# shared_sessions.each do |session|
#   Sharing.create!(session: session, user: User.first, description: 'Trop envie de voir ce truc')
# end
