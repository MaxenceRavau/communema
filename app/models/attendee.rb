class Attendee < ApplicationRecord
  belongs_to :sharing
  belongs_to :user
  validates :sharing, uniqueness: {scope: :user}
end
