module GroupsHelper

def get_group_wallpaper_path(group,style) 
   logger.info "**group.wallpapers*** #{group.wallpapers.inspect}******"
    if group.wallpapers != nil and group.wallpapers.exists?
      if style != nil
         add_host_prefix(group.wallpapers.last.photo.url(style))
      else    
         add_host_prefix(group.wallpapers.last.photo.url)
      end   
    else
      return nil
    end    
  end 

  def add_host_prefix(url)
    URI.join(request.url, url).to_s
  end 

end
