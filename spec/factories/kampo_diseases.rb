FactoryBot.define do
  factory :kampo_disease do
    association :kampo
    association :disease
  end
end
