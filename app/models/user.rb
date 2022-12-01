class User < ApplicationRecord
  has_many :sharings, dependent: :destroy
  has_many :attendees, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :follows, dependent: :destroy, foreign_key: :follower_id
  has_many :followed_users, through: :follows, source: :followee

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
