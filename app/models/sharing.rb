class Sharing < ApplicationRecord
  belongs_to :session
  has_one :movie, through: :session
  belongs_to :user
  has_many :messages, dependent: :destroy
  has_many :attendees, dependent: :destroy
  has_many :users, through: :attendees
  has_many :messages
  after_create :create_attendee

  def create_attendee
    Attendee.create(sharing_id: id, user_id: user.id)
  end
end
