class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :setup_user, only: [:show, :edit, :update, :destroy]
  
  def index
    @users = User.all
  end

  def show
  end

  def edit

  end

  def update
    if user_params[:password].blank?
      user_params.delete(:password)
      user_params.delete(:password_confirmation)
    end

    successfully_updated = if needs_password?(@user, user_params)
                             @user.update(user_params)
                           else
                             @user.update_without_password(user_params)
                           end

    if successfully_updated
      sign_in(@user, :bypass => true)
      redirect_to @user
      flash[:success] = "User account was successfully updated!"
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = "User account was successfully deleted!"
      redirect_to users_path
    else
      flash[:warning] = "Unable to delete user account!"
      redirect_to @user
    end
  end

  private

  def setup_user
    @user = User.find(params[:id])
    
    unless current_user.admin || current_user.id == @user.id 
      flash[:warning] = "You do not have access!"
      redirect_to "/"
    end
  end

  def user_params
    params.require(:user).permit(
      :first_name, :last_name, :address_1, :address_2, :city, :state, :zip, :phone, :stripe_customer_id, :admin, :email, :password
    )
  end

  def needs_password?(user, params)
    params[:password].present?
  end
end