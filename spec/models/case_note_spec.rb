# spec/models/case_note_spec.rb
require "rails_helper"

RSpec.describe CaseNote, type: :model do
  let(:user) do
    User.create!(
      email: "note@example.com",
      password: "password",
      password_confirmation: "password"
    )
  end

  it "is valid with user and body" do
    note = CaseNote.new(user: user, body: "memo")
    expect(note).to be_valid
  end

  it "is invalid without body" do
    note = CaseNote.new(user: user, body: nil)
    expect(note).not_to be_valid
    expect(note.errors[:body]).to be_present
  end

  it "is invalid when body exceeds 1000 chars" do
    note = CaseNote.new(user: user, body: "a" * 1001)
    expect(note).not_to be_valid
    expect(note.errors[:body]).to be_present
  end

  it "allows nil kampo and nil search_session" do
    note = CaseNote.new(user: user, body: "memo", kampo: nil, search_session: nil)
    expect(note).to be_valid
  end
end
