require "application_responder"

class ApplicationController < ActionController::Base
  include ApplicationHelper
  protect_from_forgery with: :exception

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

  def gon_current_user
    gon.current_user_id = current_user.id if current_user
  end
end
