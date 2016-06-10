class AddGroupIdToWallpapers < ActiveRecord::Migration
  def change
  	add_column :wallpapers, :group_id, :integer
  end
end
