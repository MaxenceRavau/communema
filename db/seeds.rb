# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

@titanic = Movie.create(title: "Titanic", synopsis: "le bateau coule", genre: "drame", release_date: 1995, duration: 120, director: "James Cameron", market_rating: 5)

@avatar = Movie.create(title: "avatar", synopsis: "blue guys", genre: "action", release_date: 2009, duration: 120, director: "James Cameron", market_rating: 4)

puts "seed is done"
