class Attendee < ApplicationRecord
  belongs_to :sharing
  belongs_to :user
end
