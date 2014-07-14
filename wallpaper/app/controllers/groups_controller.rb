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
  	#@group = Group.includes([:wallpapers,:memberships => :user]).find(params[:id])
    
    #@users = []
    
    #@group.memberships.zip(@group.users).each do |membership, user|
    #    @full_user = {:user => user, :administrator => membership.administrator, :status => membership.status};
    #    @users << @full_user
    #end

    #@group_result =  { :id => @group.id, :name => @group.name,:wallpaper => @group.wallpapers[0], :users => @users}

    
    @group = Group.includes([:memberships => :user]).find(params[:id])
    
    @users = []
    
    @group.memberships.zip(@group.users).each do |membership, user|
        @full_user = {:user => user, :administrator => membership.administrator, :status => membership.status};
        @users << @full_user
    end

    @group_result =  { :id => @group.id, :name => @group.name, :users => @users}
   
   
    respond_to do |format|
        format.html
        format.json { render :json => {:group => @group_result , :status => 1 ,:message => "OK"}}
    end

  end

  def index
      @groups = Group.all
   	   respond_to do |format|
        format.html
        format.json { render :json => @groups.to_json }
        end
  end

   def groups_by_user
     
      @groups_temp = Group.all(:include => {:memberships => :user}, :conditions => ['users.id=?', params[:id]])
      @groups = Group.includes([:memberships => :user]).where(:id => @groups_temp.map{|group| group.id})

      
      @group_result = []
      @groups.each do |group|
          @users = []
          group.memberships.zip(group.users).each do |membership, user|
              @full_user = {:user => user, :administrator => membership.administrator, :status => membership.status};
              @users << @full_user
          end
          @group_result <<  { :id => group.id, :name => group.name, :users => @users}
      end     

       respond_to do |format|
        format.html
        format.json { render :json =>{:groups => @group_result , :status => 1 ,:message => "OK"}}
        end
  end

  def save_user
    @user  = User.find(:all, :conditions => [ "phone = ?", group_user_params[:phone]])
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
  
  def send_notification
    @group = Group.find(notification_params[:group_id]);

    uri = URI.parse("https://android.googleapis.com/gcm/send")
    http = Net::HTTP.new(uri.host)
    request = Net::HTTP::Post.new(uri.request_uri)
    
    registration_ids = []
    @group.users.each do |user|
      unless user.registrationId.nil?
        registration_ids <<  user
      end  
    end  

    request.body= {
        :registration_ids =>  registration_ids,
        :data => {
          :wallpaper => "tata"
        }
      }.to_json

    # request.body= {
    #     :registration_ids => ["APA91bEkPaZ-9OgCsyiarZzWygfaBr-sjpTigILRsQZq1b3T-QmNxK1TwoWGxNCOoPsc1l0qECkaJQ-4hZ7sf2JGOUKJWSh2t9uB4Kg5CtzbvkOfkVzJqN0Nqb1sktgIJlQfDL6qw0ojIBuoRtnuBBa1bDHwqhXX49JFo8vJl2opwBUD7WgjVvg"],
    #     :data => {
    #       :toto => "tata"
    #   }.to_json

    request["Authorization"] = "key=AIzaSyDZlgujjp_pKOUftg3UXVTczyvf7ZHPR-Y"
    request["Content-Type"] = "application/json"
    response = http.request(request)
    render :json => response.body
  end




  	

private
  def group_params
    params.require(:group).permit(:user_id,:name)
  end

  def group_user_params
    params.require(:group_user).permit(:phone,:group_id)
  end

  def wallpaper_params
    params.require(:wallpaper).permit(:group_id,:photo)
  end

  def notification_params
    params.require(:notification).permit(:group_id)
  end

   def user_params
    params.require(:user).permit(:user_id)
  end
end
