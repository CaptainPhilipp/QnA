# frozen_string_literal: true

require 'application_responder'
class ApplicationController < ActionController::Base
  include Pundit
  include ApplicationHelper
  protect_from_forgery with: :exception

  self.responder = ApplicationResponder
  respond_to :html, :js, :json

  before_action :gon_current_user

  rescue_from Pundit::NotAuthorizedError do |exception|
    respond_to do |format|
      unauthorized_respond_to(format, exception)
    end
  end

  private

  def unauthorized_respond_to(format, exception)
    format.js   { head :unauthorized }
    format.json { head :unauthorized }
    format.html { redirect_to root_url, notice: exception.message }
  end

  def gon_current_user
    gon.current_user_id = current_user.id if current_user
  end
end
