FactoryGirl.define do
  sequence(:file) { |i| File.open("#{Rails.root}/spec/upload_fixtures/#{i % 4}_test.rb") }

  factory :attachment do
    file
  end
end
