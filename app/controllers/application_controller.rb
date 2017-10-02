class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private

  def authorize_admin
    return if current_user && current_user.admin?
    redirect_to root_path, alert: 'Admins only!'
  end
end
