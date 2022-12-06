class Movie < ApplicationRecord
  has_many :reviews, dependent: :destroy
  has_many :sessions, dependent: :destroy
  has_many :cinemas, -> { distinct }, through: :sessions
  has_one_attached :photo

  scope :top_rated, -> { where("market_rating > 7").order(market_rating: :desc) }
  scope :sorties_semaine, -> { where(release_date: "Wed, 30 Nov 2022") }

  def rating_for_user(user)
    Review.where(user: user.followed_users, movie: self).average(:rating)
  end

  def rating_for_movie
    reviews.average(:rating).round(2)
  end

  # def self.top_rated
  #   Movie.where("market_rating > 6")
  # end
end
