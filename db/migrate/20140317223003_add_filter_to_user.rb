class AddFilterToUser < ActiveRecord::Migration
  def change
    add_column :users, :filter, :boolean
  end
end
