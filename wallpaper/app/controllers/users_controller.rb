class UsersController < ApplicationController
  include UsersHelper

  respond_to :html, :xml, :json	
  def new

  end
 
  def create
  	
     if User.where(:phone => user_params[:phone]).first != nil
        render :json => {:status => RESPONSE_ERROR_USER_ALREADY_EXISTS ,:message => "Error"}
        return
     end   

     @user = User.new(user_params)
     @user.update_attributes :phone => get_phone_number(user_params[:phone],user_params[:countryCode])

     @user.code = random_number
     @user.save
     
     # send_confirmation_code
     respond_to do |format|
        format.html { redirect_to @user}
        format.json { render :json => {:id => @user.id,:name => @user.name,:phone => @user.phone, :countryCode => @user.countryCode, :status => RESPONSE_OK ,:message => "OK"}}
     end   
  end

  def show
  	@user = User.find(params[:id])
   respond_to do |format|
        format.html
        format.json { render :json => @user.to_json }
    end

  end

  def index
  	  @users = User.all
  	  respond_to do |format|
	      format.html
	      format.json { render :json => @users.to_json }
    end
  end


  def register
      @user = User.find(register_params[:id])
      @user.update_attributes :registrationId => register_params[:registrationId]
      @user.save
      
      respond_to do |format|
        format.html
        format.json {  render :json => {:registrationId => @user.registrationId, :status => RESPONSE_OK ,:message => "OK"}}  
    end
  end
 

 def confirm_registration
      @user = User.find(confirm_params[:id])
      if @user.code == confirm_params[:code]
        render :json => {:status => RESPONSE_OK ,:message => "OK"} 
      else
        render :json => {:status => RESPONSE_ERROR_CODE_NOT_CORRECT ,:message => "Code not correct"}  
      end  
      
  end

  def resend_code
    @user = User.find(resend_code_params[:id])
    @user.code = random_number
    @user.save
    
    if send_confirmation_code?
        render :json => {:status => RESPONSE_OK ,:message => "OK"} 
    else
        render :json => {:status => RESPONSE_ERROR_SENDING_CODE ,:message => "Error in sending code"}  
    end  

  end  
  	
  def send_confirmation_code
    user = "mayos53"
    password ="HaVMZFHMEVDQTC"
    api_id = "3490213"
    number = @user.phone

    url_send = "http://api.clickatell.com/http/sendmsg?&api_id="+api_id+"&user="+user+"&password="+password+"&to="+number.to_s+"&text="+@user.code.to_s

    logger.info url_send

    uri = URI.parse(url_send)
    http = Net::HTTP.new(uri.host)
    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)
    if response.body.start_with?("ID")
      logger.info "SMS sent"
    else
      logger.info "SMS not sent"
    end  


     

  end  


private
  def user_params
    params.require(:user).permit(:name,:email, :phone, :countryCode)
  end

  def register_params
    params.require(:user).permit(:id,:registrationId)
  end 
  def confirm_params
    params.require(:user).permit(:id,:code)
  end  

   def resend_code_params
    params.require(:user).permit(:id)
  end 


   

end

