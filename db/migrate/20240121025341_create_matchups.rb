class CreateMatchups < ActiveRecord::Migration[7.1]
  def change
    create_table :matchups do |t|
      t.integer :userOne, null: false
      t.integer :userTwo, null: false
      t.boolean :isActive,  default: true, null: false
      t.boolean :isFinalized, default: false, null: false
      t.boolean :userAccepted
      t.integer :createdBy, null: false
      t.timestamps
    end
  end
end
