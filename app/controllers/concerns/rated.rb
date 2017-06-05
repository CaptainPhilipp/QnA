module Rated
  extend ActiveSupport::Concern

  included do
    respond_to :json
  end

  def vote
    respond_to do |format|
      format.json do
        if rateable_entity.vote!(params[:value], current_user)
          render json: rateable_entity.rating
        else
          render json: '', status: :unprocessable_entity
        end
      end
    end
  end

  private

  def rateable_entity
    @rateable_entity ||= model_klass.find(params[:id])
  end

  def model_klass
    controller_name.classify.constantize
  end
end
