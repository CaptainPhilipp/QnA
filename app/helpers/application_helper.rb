module ApplicationHelper
  def current_user_owns?(entity)
    current_user && current_user.owner?(entity)
  end

  def css_id_for(entity)
    "#{entity.class.to_s.tableize.singularize}_#{entity.id || 'new'}"
  end
end
