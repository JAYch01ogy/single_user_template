class Users::InvitationsController < Devise::InvitationsController
  before_action :authorize_admin, only: [:new, :create]

  def new
    super
  end

  def create
    super
  end

  private

  def authorize_admin
    debugger
    return unless !current_user || !current_user.admin?
    redirect_to root_path, alert: 'Admins only!'
  end
end
