raclass AddTimeToWallpapers < ActiveRecord::Migration
  def change
    add_column :wallpapers, :time, :integer
  end
end
