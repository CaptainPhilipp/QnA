module Rated
  extend ActiveSupport::Concern
  include FindEntityModule

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

  def rateable_entity
    @rateable_entity ||= find_entity
  end

  def send_method_chosen_by(params_value)
    return unless current_user && current_user != rateable_entity.user && params_value
    rateable_entity.send(method_keys[params_value], current_user)
  end

  def method_keys
    { 'cancel' => :cancel_voice_of, '1' => :rate_up_by, '-1' => :rate_down_by }
  end
end
