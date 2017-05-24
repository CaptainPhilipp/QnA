module Rated
  extend ActiveSupport::Concern
  include FindEntityModule

  def vote
    send_method_chosen_by(params[:value]) unless current_user == rateable.user
    respond_to do |format|
      format.json { render json: rateable.rating }
    end
  end

  private

  def rateable
    @rateable_entity ||= find_entity
  end

  def send_method_chosen_by(params_value)
    rateable.send(method_keys[params_value], current_user) if current_user && params_value
  end

  def method_keys
    { 'cancel' => :cancel_voice_of, '1' => :rate_up_by, '-1' => :rate_down_by }
  end
end
