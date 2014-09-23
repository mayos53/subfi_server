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

#sort

image = nil
wallpapers = [];
if group.wallpapers != nil and group.wallpapers.exists?
  wallpapers = group.wallpapers.sort_by{|e| -e.timeSec}
  image = get_wallpaper_path(wallpapers.first,:medium)

end  



wallpapers = wallpapers.map{|wallpaper| 
  {id: wallpaper.id,path: get_wallpaper_path(wallpaper,:medium),user: wallpaper.user,timeSec: wallpaper.timeSec,title: wallpaper.title}}


  return { :id => group.id, :image => image,:name => group.name,
    :wallpapers =>  wallpapers,
    :users => users}

end  

end
