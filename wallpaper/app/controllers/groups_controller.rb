class GroupsController < ApplicationController

	respond_to :html, :xml, :json	
 
 
  def create

         logger.info "********************************************************create_params**#{group_params.inspect}*************************************"
 

     @group = Group.new(:name=>group_params[:name])
     @group.save

  	 @user = User.find(group_params[:user_id])

     @membership = Membership.new(:user => @user , :group => @group, :administrator => true , :status => 1)
     @membership.save

  	 redirect_to :action => 'groups_by_user' ,:id => @user.id,:format => 'json' and return

  end

  def show
  	@group = Group.includes([:wallpapers,:memberships => :user]).find(params[:id])
    
    @users = []
    
    @group.memberships.zip(@group.users).each do |membership, user|
       @full_user = {:user => user, :administrator => membership.administrator, :status => membership.status};
       @users << @full_user
    end

    @group_result =  { :id => @group.id, :name => @group.name,:wallpaper => add_host_prefix(group.wallpapers[0].photo.url(:medium)) , :users => @users}

    
    # @group = Group.includes([:memberships => :user]).find(params[:id])
    
    # @users = []
    
    # @group.memberships.zip(@group.users).each do |membership, user|
    #     @full_user = {:user => user, :administrator => membership.administrator, :status => membership.status};
    #     @users << @full_user
    # end

    # @group_result =  { :id => @group.id, :name => @group.name, :users => @users}
   
   
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

  def add_host_prefix(url)
    URI.join(request.url, url).to_s
  end

   def groups_by_user
     
      @groups_temp = Group.all(:include => {:memberships => :user}, :conditions => ['users.id=?', params[:id]])
      @groups = Group.includes([:wallpapers,:memberships => :user]).where(:id => @groups_temp.map{|group| group.id})

      
      @group_result = []
      @groups.each do |group|
          @users = []
          group.memberships.zip(group.users).each do |membership, user|
              @full_user = {:user => user, :administrator => membership.administrator, :status => membership.status};
              @users << @full_user
          end
          logger.info "********************************************************photo**#{group.wallpapers[0].photo.url(:medium)}************"
          @group_result <<  { :id => group.id, :name => group.name,:wallpaper => add_host_prefix(group.wallpapers[0].photo.url(:medium)) , :users => @users}
      end     

       respond_to do |format|
        format.html
        format.json { render :json =>{:groups => @group_result , :status => 1 ,:message => "OK"}}
        end
  end

  def save_user
    logger.info "********************************************************phone**#{group_user_params[:phone]}*************************************"
    @user  = User.where(:phone => group_user_params[:phone]).first
    logger.info "********************************************************user**#{@user.inspect}*************************************"

    @group = Group.find(group_user_params[:group_id])
    @membership = Membership.new(:user => @user , :group => @group, :administrator => false , :status => 1)
    @membership.save
    redirect_to group_path(@group, format: :json)
  end  

  def save_wallpaper
     @wallpaper = Wallpaper.new(wallpaper_params)
     @wallpaper.save
     @group = Group.includes([:wallpapers,:memberships => :user]).find(wallpaper_params[:group_id])
     send_notification(@group)
  end  

  def add_user

  end  

   def add_wallpaper
      @wallpaper = Wallpaper.new
   end  
  
  def send_notification(group)
    #@group = Group.find(notification_params[:group_id]);

    uri = URI.parse("https://android.googleapis.com/gcm/send")
    http = Net::HTTP.new(uri.host)
    request = Net::HTTP::Post.new(uri.request_uri)
    
    registration_ids = []
    group.users.each do |user|
      unless user.registrationId.nil?
        registration_ids <<  user
      end  
    end  
        logger.info "********************************************************group**#{group.inspect}*************************************"


    request.body= {
        :registration_ids =>  registration_ids,
        :data => {
          :wallpaper_path => group.wallpaper[0].photo.url(:medium) 
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
    if response[:failure] > 0
        render :json => {:status => -1, :message =>"error"}
    else  
        redirect_to group_path(@group, format: :json)
    end
    
  end




  	

private
  def group_params
    params.permit(:user_id,:name)
  end

  def group_user_params
    params.permit(:phone,:group_id)
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
