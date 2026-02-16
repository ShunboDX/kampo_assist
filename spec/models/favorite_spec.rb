# spec/models/favorite_spec.rb
require "rails_helper"

RSpec.describe Favorite, type: :model do
  let(:user) do
    User.create!(
      email: "fav@example.com",
      password: "password",
      password_confirmation: "password"
    )
  end

  let(:kampo) { create(:kampo) } # kampo factoryがある前提

  describe "validations / associations" do
    it "is valid with user and kampo" do
      favorite = Favorite.new(user: user, kampo: kampo)
      expect(favorite).to be_valid
    end

    it "is invalid without user" do
      favorite = Favorite.new(user: nil, kampo: kampo)
      expect(favorite).not_to be_valid
      expect(favorite.errors[:user]).to be_present
    end

    it "is invalid without kampo" do
      favorite = Favorite.new(user: user, kampo: nil)
      expect(favorite).not_to be_valid
      expect(favorite.errors[:kampo]).to be_present
    end
  end

  describe "current behavior" do
    it "currently allows duplicate favorites (no uniqueness validation)" do
      Favorite.create!(user: user, kampo: kampo)

      duplicate = Favorite.new(user: user, kampo: kampo)

      # 今の仕様では重複を許可している
      expect(duplicate).to be_valid
    end
  end
end
