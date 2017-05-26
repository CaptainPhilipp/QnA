module RatedHelper
  def entity_rated?(entity)
    current_user && entity.rated_by?(current_user)
  end

  def vote_link_for(entity, value, text)
    link_to text,
      { action: :vote, controller: controller_for(entity), id: entity, value: value },
      { remote: true, method: :post, format: :json, data: { rateable_id: entity.id } }
  end

  private

  def controller_for(entity)
    entity.class.to_s.tableize
  end
end
