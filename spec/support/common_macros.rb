# frozen_string_literal: true

module CommonMacros
  def self.included(base)
    # base.include ExampleMethods
    base.extend SpecMethods
  end

  # module ExampleMethods; end

  module SpecMethods
    def assign_users(*names)
      names = %i[user other_user] if names.empty?
      names.each do |name|
        let(name) do
          user = create :user
          user.confirm
          user
        end
      end
    end

    def assign_user(name = :user)
      assign_users(name)
    end

    def assign_other_user
      assign_user :other_user
    end
  end
end
