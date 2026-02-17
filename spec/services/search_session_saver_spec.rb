require "rails_helper"

RSpec.describe SearchSessionSaver do
  let!(:user) { create(:user) }

  it "creates a search_session when conditions present" do
    saver = described_class.new(
      user: user,
      medical_area_ids: [ "1" ],
      disease_ids: [ "2" ],
      symptom_ids: [ "3" ]
    )

    ss = saver.call
    expect(ss).to be_present
    expect(ss).to be_persisted
    expect(ss.conditions_hash).to be_present
  end

  it "returns nil when user is nil" do
    saver = described_class.new(user: nil, medical_area_ids: [ "1" ], disease_ids: [], symptom_ids: [])
    expect(saver.call).to be_nil
  end

  it "returns nil when all conditions blank" do
    saver = described_class.new(user: user, medical_area_ids: [ "" ], disease_ids: [], symptom_ids: [])
    expect(saver.call).to be_nil
  end
end
