FactoryBot.define do
  factory :kampo_symptom do
    association :kampo
    association :symptom
  end
end
