module ApplicationHelper
  def css_id_for(entity)
    "#{entity.class.to_s.underscore}_#{entity.id || 'new'}"
  end

  def has_errors_selector(entity, field)
     'has-error' if entity.errors[field].any?
  end

  def error_massages_for(entity, field)
    return if entity.errors.empty?
    entity
      .errors[field]
      .map { |error| "<p class='text-danger'>#{error}</p>" }
      .join.html_safe
  end
end
