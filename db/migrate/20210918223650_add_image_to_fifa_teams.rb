class AddImageToFifaTeams < ActiveRecord::Migration[6.1]
  def change
    add_column :fifa_teams, :img, :string
  end
end
