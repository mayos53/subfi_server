class Group < ActiveRecord::Base
	has_many :memberships
	has_many :recommendations
	has_many :users , :through => :memberships
	has_many :wallpapers
	has_many :events


	

  
end
