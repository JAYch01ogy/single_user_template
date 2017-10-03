class UsersController < ApplicationController
  before_action :authorize_admin, only: [:index, :show]
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end
end
