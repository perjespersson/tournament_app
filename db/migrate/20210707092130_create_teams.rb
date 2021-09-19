class CreateTeams < ActiveRecord::Migration[6.1]
  def change
    create_table :teams do |t|
      t.string :name
      t.references :tournament, null: false, foreign_key: true

      t.timestamps
    end
  end
end
