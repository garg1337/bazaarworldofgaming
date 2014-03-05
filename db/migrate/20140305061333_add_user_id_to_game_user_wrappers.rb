class AddUserIdToGameUserWrappers < ActiveRecord::Migration
  def change
  	add_column :game_user_wrappers, :user_id, :integer
  end
end
