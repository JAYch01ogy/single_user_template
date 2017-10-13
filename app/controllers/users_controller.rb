class UsersController < ApplicationController
  before_action :authorize_admin, only: [:index, :show, :destroy]
  def index
    @users = User.all
  end

  def show
    find_user
  end

  def edit
    find_user
  end

  def update
    find_user
    if @user.update(user_params)
      flash[:notice] = 'Successfully updated user.'
      redirect_to user_path
    else
      flash[:error] = 'User was not updated.'
      redirect_to edit_user_path
    end
  end

  def destroy
    find_user
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

    def find_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:email, :name)
    end
end
