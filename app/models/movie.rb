class Movie < ApplicationRecord
  has_many :reviews, dependent: :destroy
  has_many :sessions, dependent: :destroy
  has_many :sharings, through: :sessions
  has_many :cinemas, -> { distinct }, through: :sessions
  has_one_attached :photo

  scope :top_rated, -> { where("market_rating > 7").order(market_rating: :desc) }
  scope :sorties_semaine, -> { where("release_date > ?", Date.parse("22/12/07").to_time) }

  def rating_for_user(user)
    followee_reviews = Review.where(user: user.followed_users, movie: self)
    return rand(3.5..4.8).round(1) unless followee_reviews.present?

    followee_reviews.average(:rating)&.round(1)
  end

  def rating_for_movie
    reviews.average(:rating)&.round(1)
  end

  def sharings_of_followed_users(user)
    sharings.where(user: user.followed_users)
  end

  # def self.top_rated
  #   Movie.where("market_rating > 6")
  # end
end
