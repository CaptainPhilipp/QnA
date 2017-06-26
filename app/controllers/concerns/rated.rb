module Rated
  extend ActiveSupport::Concern

  def vote
    authorize_rateable
    rateable_entity.vote!(params[:value], current_user)
    render json: rateable_entity.rating
  end

  private

  def authorize_rateable
    authorize! :vote, rateable_entity
  end

  def rateable_entity
    @rateable_entity ||= model_klass.find(params[:id])
    authorize @rateable_entity
    @rateable_entity
  end

  def model_klass
    controller_name.classify.constantize
  end
end
