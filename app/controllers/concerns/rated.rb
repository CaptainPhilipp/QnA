module Rated
  extend ActiveSupport::Concern

  def vote
    rateable_entity.vote!(params[:value], current_user)
    render json: rateable_entity.rating
  end

  private

  def rateable_entity
    @rateable_entity ||= model_klass.find(params[:id])
  end

  def model_klass
    controller_name.classify.constantize
  end
end
