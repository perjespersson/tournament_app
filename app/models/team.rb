class Team < ApplicationRecord
  belongs_to :tournament
  has_many :games

  has_many :games_as_home_team, :class_name => 'Game', :foreign_key => 'home_team_id'
  has_many :games_as_away_team, :class_name => 'Game', :foreign_key => 'away_team_id'

  validates :name, presence: true
end
