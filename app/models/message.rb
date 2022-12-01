class Message < ApplicationRecord
  belongs_to :user
  belongs_to :sharing

  def sender?(a_user)
    user.id == a_user.id
  end
end
