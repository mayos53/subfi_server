class Wallpaper < ActiveRecord::Base
	belongs_to :group,	  :foreign_key => "group_id"
	belongs_to :user,	  :foreign_key => "user_id"


	has_attached_file :photo, :styles => { :medium => "300x300"}, :default_url => "/images/:style/missing.png",
	:url  => "/assets/wallpapers/:id/:style/:basename.:extension",
    :path => ":rails_root/public/assets/wallpapers/:id/:style/:basename.:extension"
  	validates_attachment_content_type :photo, :content_type => /\Aimage\/.*\Z/

  	

end
