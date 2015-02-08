class AddAttachmentWallpaperToProfiles < ActiveRecord::Migration
  def self.up
    change_table :profiles do |t|
      t.attachment :wallpaper
    end
  end

  def self.down
    remove_attachment :profiles, :wallpaper
  end
end
