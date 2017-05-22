module HasAssignedEntity
  extend ActiveSupport::Concern

  def assign_entity
    instance_variable_set("@#{entity_name}", find_entity)
  end

  private

  def entity_name
    @entity_name ||= controller_name.singularize
  end

  def find_entity
    model_klass.find(params[:id])
  end

  def model_klass
    controller_name.classify.constantize
  end
end
