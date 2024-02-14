class FixMatchuStaBle < ActiveRecord::Migration[7.1]
  def change
    rename_column :matchups, :userOne, :userOneId
    rename_column :matchups, :userTwo, :userTwoId
    remove_column :matchups, :userAccepted, :boolean
    add_column :matchups, :week, :integer
  end
end