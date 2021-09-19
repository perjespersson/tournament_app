class Game < ApplicationRecord
  belongs_to :tournament
  has_many :teams
  belongs_to :team, optional: true
  belongs_to :home_team, class_name: 'Team'
  belongs_to :away_team, class_name: 'Team'
  belongs_to :home_fifa_team, class_name: 'FifaTeam'
  belongs_to :away_fifa_team, class_name: 'FifaTeam'
end
