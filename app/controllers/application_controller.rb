require "application_responder"
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

  def renderer_with_serializer
    @renderer_with_serializer ||= get_renderer_with_serializer(current_user)
  end

  def get_renderer_with_serializer(user)
    ActionController::Renderer::RACK_KEY_TRANSLATION['warden'] ||= 'warden'
    proxy = Warden::Proxy.new({}, Warden::Manager.new({})).tap do |i|
      i.set_user(user, scope: :user)
    end
    self.class.renderer.new('warden' => proxy)
  end
end
