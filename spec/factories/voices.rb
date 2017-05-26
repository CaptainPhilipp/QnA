FactoryGirl.define do
  factory :voice do
    association :user
    association :rateable, factory: :answer
  end
end
