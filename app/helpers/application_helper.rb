module ApplicationHelper
  def current_user_owns?(entity)
    current_user && current_user.owner?(entity)
  end
end
