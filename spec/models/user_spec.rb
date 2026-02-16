# spec/models/user_spec.rb
require "rails_helper"

RSpec.describe User, type: :model do
  describe "validations" do
    it "is valid with email and password when authorizations are blank" do
      user = User.new(email: "test@example.com", password: "password", password_confirmation: "password")
      expect(user).to be_valid
    end

    it "is invalid without email" do
      user = User.new(password: "password", password_confirmation: "password")
      expect(user).not_to be_valid
      expect(user.errors[:email]).to be_present
    end

    it "is invalid with duplicate email" do
      User.create!(email: "dup@example.com", password: "password", password_confirmation: "password")
      user = User.new(email: "dup@example.com", password: "password", password_confirmation: "password")

      expect(user).not_to be_valid
      expect(user.errors[:email]).to be_present
    end

    it "requires password when authorizations are blank" do
      user = User.new(email: "no-pass@example.com", password: nil, password_confirmation: nil)
      expect(user).not_to be_valid
      expect(user.errors[:password]).to be_present
    end

    it "does not require password when authorizations exist" do
      # authorizations が1つでもあれば password_required? は false
      user = User.new(email: "oauth@example.com", password: nil, password_confirmation: nil)
      user.authorizations.build(provider: "google", uid: "12345") # カラム名が違うなら合わせてください
      expect(user).to be_valid
    end
  end

  describe "enum" do
    it "defaults to user role (or can be set)" do
      user = User.new(email: "role@example.com", password: "password", password_confirmation: "password")
      user.role = :admin
      expect(user).to be_admin
      expect(user.admin_user?).to eq(true)
    end
  end
end
