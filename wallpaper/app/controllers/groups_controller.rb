class GroupsController < ApplicationController
  include GroupsHelper
  include UsersHelper

	respond_to :html, :xml, :json	
 
 
  def create

         logger.info "********************************************************create_params**#{group_params.inspect}*************************************"
    

     #check if group exists
     if Group.where(:name => group_params[:name]).first != nil
        render :json => {:status => RESPONSE_ERROR_GROUP_ALREADY_EXISTS ,:message => "Error"}
        return
     end   

     @group = Group.new(:name=>group_params[:name])
     @group.save

  	 @user = User.find(group_params[:user_id])

     @membership = Membership.new(:user => @user , :group => @group, :administrator => true , :status => 1)
     @membership.save

  	 redirect_to :action => 'groups_by_user' ,:id => @user.id,:format => 'json' and return

  end

  def show
  	@group = Group.includes([:wallpapers => :user,:memberships => :user]).find(params[:id])
    @group_result =  get_group_full_details(@group)

    render :json => {:group => @group_result , :status => RESPONSE_OK ,:message => "OK"}
    

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
      @groups = Group.includes([:wallpapers=> :user,:memberships => :user]).where(:id => @groups_temp.map{|group| group.id})

      
      @group_result = []
      @groups.each do |group|
          @group_result <<  get_group_full_details(group)
      end     

       render :json =>{:groups => @group_result , :status => RESPONSE_OK ,:message => "OK"}
        
  end

  def save_user
    
    @user = User.find(group_user_params[:id])
    @group = Group.find(group_user_params[:group_id])

          @membership = Membership.new(:user => @user , :group => @group, :administrator => false , :status => 1)
          @membership.save
          redirect_to group_path(@group, format: :json)
        
  end  

  

  def save_wallpaper
     @wallpaper = Wallpaper.new(wallpaper_params)
     @wallpaper.timeSec =  Time.now.to_i
     @wallpaper.save
    

     @group = Group.includes([:wallpapers,:memberships => :user]).find(wallpaper_params[:group_id])
     send_notification
  end  

  def add_user

  end  

  def remove_member_from_group
     Membership.where(:user_id => group_user_params[:id]).where(:group_id=> group_user_params[:group_id]).first.destroy
     @group = Group.find(group_user_params[:group_id])
     redirect_to group_path(@group, format: :json)
  end
  
  def remove_group_from_member
     Membership.where(:user_id => group_user_params[:id]).where(:group_id=> group_user_params[:group_id]).first.destroy
     redirect_to :action => 'groups_by_user' ,:id => group_user_params[:id],:format => 'json' and return
     
  end 

  def change_group_status
     membership = Membership.where(:user_id => group_status_params[:id]).where(:group_id=> group_status_params[:group_id]).first
     membership.update_attributes :status => group_status_params[:status]
     membership.save

     redirect_to :action => 'groups_by_user' ,:id => group_status_params[:id],:format => 'json' and return
     
  end   

   def add_wallpaper
      @wallpaper = Wallpaper.new
   end  
  
  def send_notification

    uri = URI.parse("https://android.googleapis.com/gcm/send")
    http = Net::HTTP.new(uri.host)
    request = Net::HTTP::Post.new(uri.request_uri)
    
    registration_ids = []
    @group.memberships.zip(group.users).each do |membership, user|
      if user.registrationId != nil and membership.status == 1
          registration_ids <<  user.registrationId
      end
    end

  


    request.body= {
        :registration_ids =>  registration_ids,
        :data => {
          :wallpaper_path => get_group_wallpaper_path(@group,nil),
          :title => @wallpaper.title,
          :user_id => @wallpaper.user.id,
          :group_id => @group.id
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
    logger.info "**********#{response.body.inspect}*****"
    response_parsed = JSON.parse(response.body)

    if response_parsed["failure"] > 0
        render :json => {:status => RESPONSE_ERROR, :message =>"error"}
    else  
        redirect_to group_path(@group, format: :json)
    end
    
  end




  	

private
  def group_params
    params.permit(:user_id,:name)
  end

  def group_user_params
    params.permit(:id,:group_id)
  end

  def wallpaper_params
    params.require(:wallpaper).permit(:group_id,:photo,:user_id,:title)
  end

  def notification_params
    params.require(:notification).permit(:group_id)
  end

   def user_params
    params.require(:user).permit(:user_id)
  end

  def get_wallpapers_params
    params.require(:wallpaper).permit(:group_id)
  end
  def group_status_params
    params.permit(:id,:group_id,:status)
  end

end
