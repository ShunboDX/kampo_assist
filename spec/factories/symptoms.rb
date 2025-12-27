FactoryBot.define do
  factory :symptom do
    association :medical_area
    sequence(:name) { |n| "症状#{n}" }
  end
end
