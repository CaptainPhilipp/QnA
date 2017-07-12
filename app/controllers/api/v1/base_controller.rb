# frozen_string_literal: true

module Api::V1
  class BaseController < ApplicationController
    before_action :doorkeeper_authorize!
    after_action :verify_authorized

    private

    def current_resource_owner
      return if doorkeeper_token.nil?
      @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id)
    end

    def pundit_user
      current_resource_owner
    end
  end
end
