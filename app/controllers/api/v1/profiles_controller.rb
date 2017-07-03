module Api::V1
  class ProfilesController < BaseController
    def me
      authorize current_resource_owner
      respond_with current_resource_owner
    end

    def index
      authorize User
      respond_with other_users_list
    end

    private

    def other_users_list
      User.select(:id, :email, :created_at, :updated_at)
          .where.not(id: current_resource_owner.id)
    end
  end
end
