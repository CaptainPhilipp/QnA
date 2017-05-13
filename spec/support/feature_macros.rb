module FeatureMacros
  def self.included(base)
    base.include ExampleMethods
    base.extend FeatureMethods
  end

  module ExampleMethods
    def login_user(user)
      visit new_user_session_path
      fill_login_user(user)
    end

    alias instance_login_user login_user

    def fill_login_user(user)
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_on 'Log in'
    end

    def expect_standart_form(model, args = { factory: nil, link: nil, fields: [] })
      snakecased = model.to_s.tableize.singularize
      attributes = attributes_for(args[:factory] || snakecased)

      args[:fields].each do |field|
        fill_in "##{snakecased}_#{field}", with: attributes[field]
      end

      click_on I18n.t(args[:link])
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
