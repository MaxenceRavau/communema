class User < ApplicationRecord
  has_many :sharings, dependent: :destroy
  has_many :attendees, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :follows, dependent: :destroy
  has_many :followers, through: :follows, source: :follower, class_name: "User"
  has_many :followees, through: :follows, source: :followee, class_name: "User"

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
