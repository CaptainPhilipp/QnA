module UsersMacros
  def assign_user
    let(:user) { create :user }
  end

  def assign_other_user
    let(:other_user) { create :user }
  end

  def assign_users
    assign_user
    assign_other_user
  end
end
