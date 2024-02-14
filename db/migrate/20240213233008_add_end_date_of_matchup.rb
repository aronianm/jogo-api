class AddEndDateOfMatchup < ActiveRecord::Migration[7.1]
  def change
    add_column :matchups, :endDate, :date
  end
end
