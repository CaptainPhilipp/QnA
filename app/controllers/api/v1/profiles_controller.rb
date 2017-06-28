module Api
  class V1::ProfilesController < ApplicationController
    before_action :doorkeeper_authorize!

    def me
      render nothing: true
    end

    def users
      render nothing: true
    end
  end
end
