class CreateGameUserWrappers < ActiveRecord::Migration
  def change
    create_table :game_user_wrappers do |t|

      t.timestamps
    end
  end
end
