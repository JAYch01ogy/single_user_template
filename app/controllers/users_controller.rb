class UsersController < ApplicationController
  before_action :authorize_admin, only: [:index, :destroy]
  before_action :correct_user, only: [:show, :edit, :update]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = 'Successfully updated user.'
      redirect_to user_path
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.admin?
      flash[:error] = 'You cannot delete the admin user.'
      redirect_to users_path
    else
      if @user.destroy
        flash[:notice] = 'Successfully deleted user.'
        redirect_to users_path
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :name)
  end

  def correct_user
    @user = User.find(params[:id])
    unless @user == current_user || (current_user && current_user.admin?)
      flash[:error] = 'Access denied.'
      redirect_to root_path
    end
  end
end
