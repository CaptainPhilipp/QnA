FactoryGirl.define do
  factory :oauth_authorization do
    user nil
    provider "MyString"
    uid "MyString"
  end
end
