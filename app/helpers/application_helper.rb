module ApplicationHelper
  def current_user_owns?(entity)
    current_user && current_user.owner?(entity)
  end

  def css_id_for(entity)
    "#{entity.class.to_s.underscore}_#{entity.id || 'new'}"
  end

  def has_errors_selector(entity, field)
     'has-error' if entity.errors[field].any?
  end

  def errors(entity, field)
    return if entity.errors.empty?
    entity
      .errors[field]
      .map { |error| "<p class='text-danger'>#{error}</p>" }
      .join.html_safe
  end
end
