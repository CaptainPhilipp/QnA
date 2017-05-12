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

    def should_not_change(entity, *fields)
      old_values = fields.map { |field| entity.send field }
      yield
      entity.reload
      fields.each_with_index do |field, i|
        expect(entity.send field).to eq old_values[i]
      end
    end
  end

  module SpecMethods
    def login_user
      assign_user
      before { login_user user }
    end

    def login_other_user
      assign_other_user
      before { login_user other_user }
    end
  end
end
