class CreateLeagues < ActiveRecord::Migration[7.1]
  def change
    create_table :leagues do |t|
      t.string :leagueName
      t.string :leagueCode
      t.integer :numberOfWeeks
      t.timestamps
    end

    create_table :user_leagues do |t|
      t.integer :user_id
      t.integer :wins
      t.integer :losses
      t.integer :league_id
    end

    add_column :seasons, :league_id, :integer
    add_column :matchups, :league_id, :integer
  end
end
