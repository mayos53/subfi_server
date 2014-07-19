class User < ActiveRecord::Base
	has_many :memberships
	has_many :groups , :through => :memberships

	# Exclude created_at info from json output.
   def to_json(options={})
     options[:except] ||= [:created_at, :updated_at]
     super(options)
   end

   def to_h
   	{
   		id: self.id,
   		name: self.name
   		phone: self.phone

   	}			
   end	
end
