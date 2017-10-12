class UsersController < ApplicationController
  before_action :authorize_admin, only: [:index, :show, :destroy]
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
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
end
