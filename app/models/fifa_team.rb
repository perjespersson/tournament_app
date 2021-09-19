class FifaTeam < ApplicationRecord
  has_many :games

  has_many :games_as_home_fifa_team, :class_name => 'Game', :foreign_key => 'home_fifa_team_id'
  has_many :games_as_away_fifa_team, :class_name => 'Game', :foreign_key => 'away_fifa_team_id'
end
