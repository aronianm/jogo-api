class AddGameCenterIdtoUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :game_center_id, :string
  end
end
