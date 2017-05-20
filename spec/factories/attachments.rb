FactoryGirl.define do
  sequence(:file) { |i| File.open("#{Rails.root}/spec/uploads/#{i % 4}_test.rb") }

  factory :attachment do
    file
  end
end
