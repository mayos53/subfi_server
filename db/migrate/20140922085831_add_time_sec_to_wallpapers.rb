class AddTimeSecToWallpapers < ActiveRecord::Migration
  def change
    add_column :wallpapers, :timeSec, :integer
  end
end
