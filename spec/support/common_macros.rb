module CommonMacros
  def self.included(base)
    base.include ExampleMethods
    base.extend SpecMethods
  end

  module ExampleMethods; end

  module SpecMethods
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
end
