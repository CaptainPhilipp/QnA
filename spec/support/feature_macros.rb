module FeatureMacros
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module InstanceMethods
    def login_user(user)
      visit new_user_session_path
      fill_login_user(user)
    end

    def fill_login_user(user)
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_on 'Log in'
    end

    def create_question_with_form(attributes = nil)
      attributes ||= { title: 'Question title', body: 'Question body' }

      fill_in Question.human_attribute_name(:title), with: attributes[:title]
      fill_in Question.human_attribute_name(:body),  with: attributes[:body]
      click_on I18n.t(:create, scope: 'questions.form')
    end
  end

  module ClassMethods
    def login_user
      assign_user
      before { login_user(user) }
    end

    def login_other_user
      assign_other_user
      before { login_user(other_user) }
    end
  end
end
