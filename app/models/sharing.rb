class Sharing < ApplicationRecord
  belongs_to :session
  belongs_to :user
  has_many :messages, dependent: :destroy
  has_many :attendees, dependent: :destroy
end
