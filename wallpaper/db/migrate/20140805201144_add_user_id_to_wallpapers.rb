class AddUserIdToWallpapers < ActiveRecord::Migration
  def change
    add_column :wallpapers, :user_id, :string
  end
end
