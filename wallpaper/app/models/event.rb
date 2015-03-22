EVENT_TYPE_LEAVE_GROUP = 1

class Event < ActiveRecord::Base
	belongs_to :user , :foreign_key => "user_id"
	belongs_to :group, :foreign_key => "group_id"

end
