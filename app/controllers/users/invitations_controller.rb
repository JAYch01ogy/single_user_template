class Users::InvitationsController < Devise::InvitationsController
  before_action :authorize_admin, only: [:new, :create]
  #
  # def new
  #   super
  # end
  #
  # def create
  #   super
  # end
end
