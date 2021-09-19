class Tournament < ApplicationRecord
  has_many :teams
  has_many :games

  validates :name, presence: true
  validates :pin, presence: true
end
