class AddAttachmentPhotoToWallpapers < ActiveRecord::Migration
  def self.up
    change_table :wallpapers do |t|
      t.attachment :photo
    end
  end

  def self.down
    drop_attached_file :wallpapers, :photo
  end
end
