# frozen_string_literal: true

module ControllerMacros
  def self.included(base)
    base.include ExampleMethods
    base.extend SpecMethods
  end

  module ExampleMethods
    def login_user(user)
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in user
    end

    alias instance_login_user login_user

    def should_not_change(entity, *fields)
      old_values = fields.map { |field| entity.send field }
      yield
      entity.reload
      fields.each_with_index do |field, i|
        expect(entity.send(field)).to eq old_values[i]
      end
    end
  end

  module SpecMethods
    def login_user(user_name = :user)
      assign_user user_name
      before { instance_login_user send(user_name) }
    end
  end
end
