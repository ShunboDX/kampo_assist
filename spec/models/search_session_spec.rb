# spec/models/search_session_spec.rb
require "rails_helper"

RSpec.describe SearchSession, type: :model do
  let(:user) { User.create!(email: "ss@example.com", password: "password", password_confirmation: "password") }

  it "is valid with user and conditions (conditions_hash is generated)" do
    ss = SearchSession.new(
      user: user,
      conditions: { "medical_area_ids" => [ "2", "1" ], "disease_ids" => [ "", "3" ] }
    )

    expect(ss).to be_valid
    ss.save!

    expect(ss.conditions_hash).to be_present
  end

  it "normalizes array-like condition keys (removes blanks, stringifies, sorts)" do
    ss = SearchSession.create!(
      user: user,
      conditions: {
        "medical_area_ids" => [ "2", "", 1 ],
        "disease_ids" => [ 3, "1" ],
        "symptom_ids" => [ "", "10", 2 ]
      }
    )

    expect(ss.conditions["medical_area_ids"]).to eq([ "1", "2" ])
    expect(ss.conditions["disease_ids"]).to eq([ "1", "3" ])
    expect(ss.conditions["symptom_ids"]).to eq([ "10", "2" ])
  end

  it "is invalid without conditions" do
    ss = SearchSession.new(user: user, conditions: nil)
    expect(ss).not_to be_valid
    expect(ss.errors[:conditions]).to be_present
  end
end
