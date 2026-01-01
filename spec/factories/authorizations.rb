FactoryBot.define do
  factory :authorization do
    association :user
    provider { "google" }
    uid { SecureRandom.hex(8) }
    email { "oauth@example.com" }
    name { "OAuth User" }
  end
end
