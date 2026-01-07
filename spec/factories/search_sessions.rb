FactoryBot.define do
  factory :search_session do
    user { nil }
    conditions { "" }
    conditions_hash { "MyString" }
  end
end
