class UsersController < ApplicationController
 
  respond_to :html, :xml, :json	
  def new

  end
 
  def create
  	 @user = User.new(user_params)
  	 @user.save
  	 redirect_to @user
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

  
  	

private
  def user_params
    params.require(:user).permit(:name,:email, :phone, :countryCode)
  end

end
