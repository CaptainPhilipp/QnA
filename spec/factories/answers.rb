FactoryGirl.define do
  factory :answer do
    association :question
    body "MyText"

    factory :invalid_answer do
      question nil
      body ''
    end
  end
end
