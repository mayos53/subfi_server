class CreateWallpapers < ActiveRecord::Migration
  def change
    create_table :wallpapers do |t|
      t.integer :status
      t.timestamp :time

      t.timestamps
    end
  end
end
