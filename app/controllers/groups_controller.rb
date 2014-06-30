class GroupsController < ApplicationController

	respond_to :html, :xml, :json	
 
 
  def create

     @group = Group.new(:name=>group_params[:name])
     @group.save

  	 @user = User.find(group_params[:user_id])

     @membership = Membership.new(:user => @user , :group => @group, :administrator => true , :status => 1)
     @membership.save

  	redirect_to groups_path
  end

  def show
  	@group = Group.includes([:wallpapers,:memberships => :user]).find(params[:id])
    
    @users = []
    
    @group.memberships.zip(@group.users).each do |membership, user|
        @full_user = {:user => user, :administrator => membership.administrator, :status => membership.status};
        @users << @full_user
    end

    @group_result =  { :id => @group.id, :name => @group.name,:wallpaper => @group.wallpapers[0], :users => @users}
   
    respond_to do |format|
        format.html
        format.json { render :json => @group_result.to_json }
    end

  end

  def index
  	  @groups = Group.all
  	   respond_to do |format|
        format.html
        format.json { render :json => @groups.to_json }
        end
  end

  def save_user
    @user  = User.find(group_user_params[:user_id])
    @group = Group.find(group_user_params[:group_id])
    @membership = Membership.new(:user => @user , :group => @group, :administrator => false , :status => 1)
    @membership.save
    redirect_to @group
  end  

  def save_wallpaper
     logger.info "********************************************************#{wallpaper_params.inspect}*************************************"
     @wallpaper = Wallpaper.new(wallpaper_params)
     @wallpaper.save
     @group = Group.find(wallpaper_params[:group_id])
     redirect_to @group
  end  

  def add_user

  end  

   def add_wallpaper
      @wallpaper = Wallpaper.new
   end  
  
  	

private
  def group_params
    params.require(:group).permit(:user_id,:name)
  end

  def group_user_params
    params.require(:group_post).permit(:user_id,:group_id)
  end

  def wallpaper_params
    params.require(:wallpaper).permit(:group_id,:photo)
  end
end
