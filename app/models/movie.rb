class Movie < ApplicationRecord
  has_many :reviews, dependent: :destroy
  has_many :sessions, dependent: :destroy
  has_many :cinemas, -> { distinct }, through: :sessions
  has_one_attached :photo

  scope :top_rated, -> { where("market_rating > 7.5").order(market_rating: :desc) }
  scope :sorties_semaine, -> { where(release_date: "Wed, 30 Nov 2022") }


  # def self.top_rated
  #   Movie.where("market_rating > 6")
  # end
end
