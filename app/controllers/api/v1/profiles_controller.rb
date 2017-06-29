module Api::V1
  class ProfilesController < BaseController
    def me
      respond_with current_resource_owner
    end

    def index
      respond_with other_users_list
    end

    private

    def other_users_list
      return if current_resource_owner.nil?
      User.select(:id, :email, :created_at, :updated_at)
          .where.not(id: current_resource_owner.id)
    end
  end
end
