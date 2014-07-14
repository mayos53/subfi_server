class UsersController < ApplicationController
 
  respond_to :html, :xml, :json	
  def new

  end
 
  def create
  	 @user = User.new(user_params)
  	 @user.save

     respond_to do |format|
        format.html { redirect_to @user}
        format.json { render :json => {:id => @user.id,:name => @user.name,:phone => @user.phone, :countryCode => @user.countryCode, :status => 1 ,:message => "OK"}}
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
        format.json {  render :json => {:registrationId => @user.registrationId, :status => 1 ,:message => "OK"}}  
    end
  end
 
  	

private
  def user_params
    params.require(:user).permit(:name,:email, :phone, :countryCode)
  end

  def register_params
    params.require(:user).permit(:id,:registrationId)
  end  

end
