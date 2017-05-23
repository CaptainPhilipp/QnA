module HasAssignedEntity
  extend ActiveSupport::Concern
  include FindEntityModule

  def assign_entity
    instance_variable_set("@#{entity_name}", find_entity)
  end

  private

  def entity_name
    @entity_name ||= controller_name.singularize
  end
end
