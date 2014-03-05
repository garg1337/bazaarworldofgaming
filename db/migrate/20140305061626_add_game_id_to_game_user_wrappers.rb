class AddGameIdToGameUserWrappers < ActiveRecord::Migration
  def change
  	add_column :game_user_wrappers, :game_id, :integer
  end
end
