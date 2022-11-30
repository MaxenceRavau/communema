class Sharing < ApplicationRecord
  belongs_to :session
  has_one :movie, through: :session
  belongs_to :user
  has_many :messages, dependent: :destroy
  has_many :attendees, dependent: :destroy
  has_many :messages
end
