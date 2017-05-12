FactoryGirl.define do
  sequence :title do |n|
    "Question #{n}"
  end

  factory :question do
    title
    body 'MyText'
    association :user

    factory :invalid_question do
      title ''
      body ''
    end

    factory :new_question do
      title 'Edited Question'
      body 'Edited Text'
    end
  end
end
