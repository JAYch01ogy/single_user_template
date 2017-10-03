class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def authorize_admin
    return if current_user && current_user.admin?
    redirect_to root_path, alert: 'Admins only!'
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:invite, keys: [:name])
  end
end
