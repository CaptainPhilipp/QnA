FactoryGirl.define do
  sequence(:email) { |i| "Some_Adress-#{i}@example.com" }

  factory :user do
    email
    password 'some-Example_passworD'
    password_confirmation 'some-Example_passworD'
    after(:create) { |user| user.confirm }
  end
end
