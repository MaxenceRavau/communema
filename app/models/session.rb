class Session < ApplicationRecord
  belongs_to :cinema
  belongs_to :movie
  has_many :sharings, dependent: :destroy

  def name
    start_at.strftime("%H:%M")
  end
end
