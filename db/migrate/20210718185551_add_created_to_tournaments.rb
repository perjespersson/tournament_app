class AddCreatedToTournaments < ActiveRecord::Migration[6.1]
  def change
    add_column :tournaments, :tournament_created, :boolean
  end
end
