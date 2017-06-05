FactoryGirl.define do
  factory :comment do
    association :user
    body 'Some comment'
  end
end
