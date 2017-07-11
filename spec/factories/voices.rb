FactoryGirl.define do
  factory :voice do
    user
    association :rateable, factory: :answer
  end
end
