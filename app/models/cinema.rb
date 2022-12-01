class Cinema < ApplicationRecord
  has_many :sessions, dependent: :destroy

  geocoded_by :location
  after_validation :geocode
end
