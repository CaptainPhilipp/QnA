require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  include ApplicationHelper
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  check_authorization
  authorize_resource

  before_action :gon_current_user

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path
  end

  private

  def gon_current_user
    gon.current_user_id = current_user.id if current_user
  end
end
