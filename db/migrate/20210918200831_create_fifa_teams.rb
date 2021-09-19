class CreateFifaTeams < ActiveRecord::Migration[6.1]
  def change
    create_table :fifa_teams do |t|
      t.string :name
      t.string :stars
      t.string :career

      t.timestamps
    end
  end
end
