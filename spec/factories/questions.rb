FactoryGirl.define do
  factory :question do
    sequence(:title) { |i| "Question #{i}" }
    body 'MyText'
    association :user

    factory :invalid_question do
      title ''
      body ''
    end

    factory :new_question do
      title 'Edited Question title'
      body 'Edited question Text'
    end
  end
end
