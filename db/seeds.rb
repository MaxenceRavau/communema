# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
Movie.destroy_all
Cinema.destroy_all
Session.destroy_all
Sharing.destroy_all
User.destroy_all

@titanic = Movie.create(title: "Titanic", synopsis: "le bateau coule", genre: "drame", release_date: 1995, duration: 120, director: "James Cameron", market_rating: 5)

@avatar = Movie.create(title: "avatar", synopsis: "blue guys", genre: "action", release_date: 2009, duration: 120, director: "James Cameron", market_rating: 4)

cinema1 = Cinema.create(name: "Mk2Paris11", location: "Paris 11", brand: "mk2")

cinema2 = Cinema.create(name: "UgcCineCité 13", location: "Paris 13", brand: "ugc")

session1 = Session.create(hall: "3", start_at: "14h", cinema: cinema1, movie: @titanic)

session2 = Session.create(hall: "6", start_at: "19h30", cinema: cinema2, movie: @avatar)

bob = User.create!(email: "bob@mail.com", password: '123456', first_name: 'Bob')

sharing1 = Sharing.create(description: "Yalla, je vais kiffer", session: session1, user: bob)



mark = User.create!(email: "mark@mail.com", password: '123456', first_name: 'Mark')
nico = User.create!(email: "nico@mail.com", password: '123456', first_name: 'Nico')

Follow.create!(follower: bob, followee: mark)
Follow.create!(follower: bob, followee: nico)

puts "seed is done"
