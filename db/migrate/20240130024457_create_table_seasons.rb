class CreateTableSeasons < ActiveRecord::Migration[7.1]
  def change
    create_table :seasons, force: true do |t|
      t.integer :userOneWins, default: 0, null: false
      t.integer :userTwoWins, default: 0, null: false
      t.bigint :matchup_id
      t.integer :active, default: true
      t.timestamps
    end

    create_table :season_matchups, force: true do |t|
      t.integer :week, default: 1, null: false
      t.bigint :season_id
      t.boolean :startMatchup, default: true
      t.float :userOneDailyScore,  default: 0.0, null: false
      t.float :userOneTotalScore,  default: 0.0, null: false
      t.float :userTwoDailyScore,  default: 0.0, null: false
      t.float :userTwoTotalScore,  default: 0.0, null: false
      t.date :userOneScoreUpdated
      t.date :userTwoScoreUpdated
      t.date :endDate, null: false
    end

    add_foreign_key :seasons, :matchups, column: :matchup_id, on_delete: :cascade
    add_foreign_key :season_matchups, :seasons, column: :season_id, on_delete: :cascade 
  end
end
