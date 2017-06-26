require "application_responder"
include Pundit
class ApplicationController < ActionController::Base
  include Pundit
  include ApplicationHelper
  protect_from_forgery with: :exception

  self.responder = ApplicationResponder
  respond_to :html

  before_action :gon_current_user

  rescue_from Pundit::NotAuthorizedError do
    redirect_to root_path
  end

  private

  def gon_current_user
    gon.current_user_id = current_user.id if current_user
  end
end
