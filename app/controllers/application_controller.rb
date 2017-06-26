require "application_responder"

class ApplicationController < ActionController::Base
  include ApplicationHelper

  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :gon_current_user

  check_authorization

  # rescue_from CanCan::AccessDenied do |exception|
  #   redirect_to root_path
  # end

  private

  def gon_current_user
    gon.current_user_id = current_user.id if current_user
  end
end
