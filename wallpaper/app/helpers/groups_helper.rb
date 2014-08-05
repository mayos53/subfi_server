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

wallpapers = group.wallpapers.map{|wallpaper| 
  {id: wallpaper.id,path: get_wallpaper_path(wallpaper,:medium),user: wallpaper.user}}


  return { :id => group.id, :name => group.name,
    :wallpapers =>  wallpapers,
    :users => users}

end  

end
