module Api
  class V1::ProfilesController < ApplicationController
    before_action :doorkeeper_authorize!

    def me
      respond_with current_resource_owner
    end

    def users
      render nothing: true
    end

    private

    def current_resource_owner
      return if doorkeeper_token.nil?
      @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id)
    end
  end
end
