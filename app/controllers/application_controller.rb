require "application_responder"

class ApplicationController < ActionController::Base
  include ApplicationHelper
  protect_from_forgery with: :exception

  self.responder = ApplicationResponder
  respond_to :html

  before_action :gon_current_user

  check_authorization

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.js   { head :unauthorized, content_type: 'text/html' }
      format.json { head :unauthorized, content_type: 'text/html' }
      format.html { redirect_to root_url, notice: exception.message }
    end
  end

  private

  def gon_current_user
    gon.current_user_id = current_user.id if current_user
  end
end
