FactoryBot.define do
  factory :authorization do
    user { nil }
    provider { "MyString" }
    uid { "MyString" }
    email { "MyString" }
    name { "MyString" }
  end
end
