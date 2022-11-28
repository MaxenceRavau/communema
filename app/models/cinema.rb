class Cinema < ApplicationRecord
  has_many :sessions, dependent: :destroy
end
