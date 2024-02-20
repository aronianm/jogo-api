class UpdateUserToMoveFromDevise < ActiveRecord::Migration[7.1]
  def change
    drop_table :users
    create_table :users do |t|
      t.string :username
      t.string :fname
      t.string :lname
      t.string :apple_game_center_id
      t.string :jwt
    end
  end
end
