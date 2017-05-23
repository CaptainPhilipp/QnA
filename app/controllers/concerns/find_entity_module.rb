module FindEntityModule
  extend ActiveSupport::Concern

  protected

  def find_entity
    model_klass.find(params[:id])
  end

  def model_klass
    controller_name.classify.constantize
  end
end
