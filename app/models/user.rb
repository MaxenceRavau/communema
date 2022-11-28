class User < ApplicationRecord
  has_many :sharings, dependent: :destroy
  has_many :attendees, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :followers, dependent: :destroy
  has_many :followees, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
