class Cinema < ApplicationRecord
  has_many :sessions, dependent: :destroy

  geocoded_by :location
end
