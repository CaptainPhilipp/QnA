module FeatureMacros
  def self.included(base)
    base.include ExampleMethods
    base.extend FeatureMethods
  end

  module ExampleMethods
    def login_user(user = :user)
      visit new_user_session_path
      fill_login_user(send user)
    end

    alias instance_login_user login_user

    def fill_login_user(user)
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_on 'Log in'
    end

    def fill_standart_form(model, args = { factory: nil, action: :create, fields: [] })
      attributes = attributes_for(args[:factory])

      args[:fields].each do |field|
        fill_in model.human_attribute_name(field), with: attributes[field]
      end

      click_on I18n.t(action, scope: "#{model.to_s.pluralize.snakeize}.form")
      args[:fields].each { |field| expect(page).to have_content attributes[field] }
    end
  end

  module FeatureMethods
    def login_user(user = :user)
      assign_user(user)
      before { instance_login_user(send user) }
    end
  end
end
