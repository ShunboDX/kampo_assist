FactoryBot.define do
  factory :user do
    email { "MyString" }
    password { "password" }
    password_confirmation { "password" }
  end
end
