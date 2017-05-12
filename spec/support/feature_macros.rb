module FeatureMacros
  def self.included(base)
    base.include ExampleMethods
    base.extend FeatureMethods
  end

  module ExampleMethods
    alias instance_login_user login_user

    def login_user(user = :user)
      visit new_user_session_path
      fill_login_user(user)
    end

    def fill_login_user(user = :user)
      fill_in 'Email', with: send(user).email
      fill_in 'Password', with: send(user).password
      click_on 'Log in'
    end

    def create_question_with_form(attributes = nil)
      attributes ||= { title: 'Question title', body: 'Question body' }

      fill_in Question.human_attribute_name(:title), with: attributes[:title]
      fill_in Question.human_attribute_name(:body),  with: attributes[:body]
      click_on I18n.t(:create, scope: 'questions.form')
    end
  end

  module FeatureMethods
    def login_user(user = :user)
      assign_user(user)
      before { instance_login_user(user) }
    end
  end
end
