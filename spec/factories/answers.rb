FactoryGirl.define do
  factory :answer do
    association :question, factory: :question
    body "MyText"
  end

  factory :invalid_answer, class: Answer do
    body ''
    question nil
  end
end
