require 'rails_helper'

RSpec.describe Authorization, type: :model do
  it "is invalid without provider" do
    auth = Authorization.new(provider: nil, uid: "123", user: build(:user))
    expect(auth).to be_invalid
  end

  it "enforces uniqueness of uid scoped to provider" do
    user = create(:user)
    create(:authorization, user:, provider: "google", uid: "123")
    dup = Authorization.new(user:, provider: "google", uid: "123")
    expect(dup).to be_invalid
  end
end
