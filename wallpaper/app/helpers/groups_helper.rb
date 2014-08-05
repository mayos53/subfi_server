module GroupsHelper

  def get_group_wallpaper_path(group,style) 
   logger.info "**group.wallpapers*** #{group.wallpapers.inspect}******"
   if group.wallpapers != nil and group.wallpapers.exists?
      get_wallpaper_path(group.wallpapers.last)
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

end
