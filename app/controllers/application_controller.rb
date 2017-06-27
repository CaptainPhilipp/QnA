require "application_responder"
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include Pundit
  include ApplicationHelper

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  self.responder = ApplicationResponder
  respond_to :html, :js, :json

  before_action :gon_current_user

  rescue_from Pundit::NotAuthorizedError do
    respond_to do |format|
      format.js   { self.status = :unauthorized }
      format.json { self.status = :unauthorized }
      format.html { redirect_to root_path }
    end
  end

  private

  def user_not_authorized
    respond_to do |format|
      format.js   { head :unauthorized, content_type: 'text/html' }
      format.json { head :unauthorized, content_type: 'text/html' }
      format.html { redirect_to root_url, notice: exception.message }
    end
  end

  def gon_current_user
    gon.current_user_id = current_user.id if current_user
  end
end
