FactoryGirl.define do
  factory :answer do
    association :user
    association :question
    sequence(:body) { |i| "Some answer #{i}" }

    factory :invalid_answer do
      question nil
      body ''
    end

    factory :new_answer do
      body 'Edited Text'
    end
  end
end
