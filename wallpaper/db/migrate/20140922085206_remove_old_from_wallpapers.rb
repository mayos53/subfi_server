class RemoveOldFromWallpapers < ActiveRecord::Migration
  def change
    remove_column :wallpapers, :field_name, :time
  end
end
