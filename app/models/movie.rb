class Movie < ApplicationRecord
  has_many :reviews, dependent: :destroy
  has_many :sessions, dependent: :destroy
  has_many :cinemas, -> { distinct }, through: :sessions
  has_one_attached :photo
end
