FactoryGirl.define do
  factory :comment do
    user
    association :commentable, factory: :question
    sequence(:body) { |i| "comment #{i}" }
  end
end
