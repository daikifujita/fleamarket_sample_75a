class UsersController < ApplicationController
  

  def show
    @user = User.find(params[:id])
    @address = Address.where(user_id: current_user.id)
  end

  def edit
  
  end

  def update
  
  end
  
  
  def logout
  
  end
  

  private
    
end
