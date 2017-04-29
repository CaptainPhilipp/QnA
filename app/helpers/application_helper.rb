module ApplicationHelper
  def user_owns_entity?(entity)
    current_user && current_user.owner?(entity)
  end
end
