class Session < ApplicationRecord
  belongs_to :cinema
  belongs_to :movie
  has_many :sharings, dependent: :destroy
end
