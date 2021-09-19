class AddFifaTeamsToGames < ActiveRecord::Migration[6.1]
  def change
    add_column :games, :home_fifa_team_id, :string
    add_column :games, :away_fifa_team_id, :string
  end
end
