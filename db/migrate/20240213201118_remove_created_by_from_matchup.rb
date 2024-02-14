class RemoveCreatedByFromMatchup < ActiveRecord::Migration[7.1]
  def change
    remove_column :matchups, :createdBy, :integer
    add_column :matchups, :userOneDailyScore, :float
    add_column :matchups, :userOneTotalScore, :float
    add_column :matchups, :userTwoDailyScore, :float
    add_column :matchups, :userTwoTotalScore, :float
    add_column :matchups, :userOneScoreUpdated, :date
    add_column :matchups, :userTwoScoreUpdated, :date

  end
end
