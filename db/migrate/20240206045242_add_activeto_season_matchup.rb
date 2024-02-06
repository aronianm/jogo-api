class AddActivetoSeasonMatchup < ActiveRecord::Migration[7.1]
  def change
    add_column :season_matchups, :active, :boolean
  end
end
