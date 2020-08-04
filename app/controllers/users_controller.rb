class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :logout]
  before_action :set_address, only: [:edit, :update]

  def

  def show
  end

  def edit
  
  end

  def update
  
  end
  
  
  def logout
  
  end
  

  private
  def set_user
    @user = User.find(params[:id])
  end
    
  def set_user
    @address = Address.find(params[:id])
  end
end
