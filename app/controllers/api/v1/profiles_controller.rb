module Api
  class V1::ProfilesController < ApplicationController
    before_action :doorkeeper_authorize!

    def me
      respond_with current_resource_owner
    end

    def users
      respond_with other_users_list
    end

    private

    def current_resource_owner
      return if doorkeeper_token.nil?
      @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id)
    end

    def other_users_list
      return if current_resource_owner.nil?
      User.select(:id, :email, :created_at, :updated_at)
          .where.not(id: current_resource_owner.id)
    end
  end
end
