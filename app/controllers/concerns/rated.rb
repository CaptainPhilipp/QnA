module Rated
  extend ActiveSupport::Concern
  include FindEntityModule

  def vote
    send_method_chosen_by(params[:value])
    respond_to do |format|
      format.json { render json: find_entity.rating }
    end
  end

  private

  def send_method_chosen_by(params_value)
    find_entity.send(method_keys[params_value], current_user) if current_user && params_value
  end

  def method_keys
    { 'cancel' => :cancel_voice_of, '1' => :rate_up_by, '-1' => :rate_down_by }
  end
end
