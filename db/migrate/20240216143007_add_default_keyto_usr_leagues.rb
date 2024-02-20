class AddDefaultKeytoUsrLeagues < ActiveRecord::Migration[7.1]
  def change
    add_column :user_leagues, :default, :boolean, default: false
  end
end
