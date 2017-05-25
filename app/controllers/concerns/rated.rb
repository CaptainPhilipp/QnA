module Rated
  extend ActiveSupport::Concern

  def vote
    respond_to do |format|
      format.json do
        if send_method_chosen_by(params[:value])
          render json: rateable_entity.rating
        else
          render json: '', status: :unprocessable_entity
        end
      end
    end
  end

  private

  def send_method_chosen_by(params_value)
    return if current_user_owns?(rateable_entity) || params_value.nil?
    rateable_entity.send(method_keys[params_value], current_user)
  end

  def rateable_entity
    @rateable_entity ||= model_klass.find(params[:id])
  end

  def model_klass
    controller_name.classify.constantize
  end

  def method_keys
    { 'cancel' => :cancel_voice_of, '1' => :rate_up_by, '-1' => :rate_down_by }
  end
end
