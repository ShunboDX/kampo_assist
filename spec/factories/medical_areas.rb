FactoryBot.define do
  factory :medical_area do
    sequence(:name) { |n| "領域#{n}" }
  end
end
