FactoryBot.define do
  factory :disease do
    association :medical_area
    sequence(:name) { |n| "病名#{n}" }
  end
end
