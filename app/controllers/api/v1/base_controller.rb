module Api::V1
  class BaseController < ApplicationController
    before_action :doorkeeper_authorize!

    private

    def current_resource_owner
      return if doorkeeper_token.nil?
      @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id)
    end
  end
end
