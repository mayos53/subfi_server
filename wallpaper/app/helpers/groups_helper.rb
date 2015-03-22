module GroupsHelper

  def get_group_wallpaper_path(group,style) 
   logger.info "**group.wallpapers*** #{group.wallpapers.inspect}******"
   if group.wallpapers != nil and group.wallpapers.exists?
      get_wallpaper_path(group.wallpapers.last,style)
   else
    return nil
  end    
end 
  
def get_wallpaper_path(wallpaper,style)
  if style != nil
   add_host_prefix(wallpaper.photo.url(style))
 else    
   add_host_prefix(wallpaper.photo.url)
 end   

end  

def add_host_prefix(url)
  URI.join(request.url, url).to_s
end 

def get_group_full_details(group)
   users = []
   group.memberships.zip(group.users).each do |membership, user|
    @full_user = user.to_h.merge({:administrator => membership.administrator, :status => membership.status});
    users << @full_user
  end

  group.recommendations.each do |recommendation|
      recommended = User.find(recommendation.user_id)
      recommended = recommended.to_h.merge({:status => -1})
      users << recommended
  end  

  events = []
  group.events.each do |event|
      events << {:user_id => event.user.id, :user_name => event.user.name, :type => event.event_type, :time => event.time}
  end  
  
  image_time = get_group_image_and_time(group)

  wallpapers = []

 #sort
  if group.wallpapers != nil and group.wallpapers.exists?
     wallpapers = group.wallpapers.sort_by{|e| -e.timeSec}
  end 

  wallpapers = wallpapers.map{|wallpaper| 
    {id: wallpaper.id,path: get_wallpaper_path(wallpaper,:medium),user: wallpaper.user,timeSec: wallpaper.timeSec,title: wallpaper.title}}
  



    return { :id => group.id, :name => group.name,
      :wallpapers =>  wallpapers,
      :users => users,
      :events => events
      }.merge(image_time)

end 

def get_group_image_and_time(group)
  image = nil
  time = nil
  if group.wallpapers != nil and group.wallpapers.exists?
    image = get_wallpaper_path(group.wallpapers.last,:medium)
    time = group.wallpapers.last.timeSec 
  end  
   logger.info "********************************************************image **#{image.inspect}*************************************"

  return {:image => image, :time => time}

end  

end
