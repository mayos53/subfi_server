class RemoveOldFromWallpapers < ActiveRecord::Migration
  def change
    remove_column :wallpapers, :time, :timestamp
  end
end
