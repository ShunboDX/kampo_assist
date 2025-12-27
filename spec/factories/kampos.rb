# spec/factories/kampos.rb
FactoryBot.define do
  factory :kampo do
    sequence(:name) { |n| "漢方#{n}" }
    sequence(:kana_name) { |n| "かんぽう#{n}" } # ★追加：NOT NULL対策
  end
end
