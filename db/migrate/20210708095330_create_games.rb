class CreateGames < ActiveRecord::Migration[6.1]
  def change
    create_table :games do |t|
      t.string :round
      t.integer :home_team_score
      t.integer :away_team_score
      t.references :tournament, null: false, foreign_key: true
      t.references :home_team
      t.references :away_team

      t.timestamps
    end
  end
end
